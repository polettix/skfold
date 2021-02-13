package SKFold::Custom;
use strict;
use warnings;
use Path::Tiny;

sub adapt_module_configuration {
   my ($config) = @_;
   $config->{whatevah} = 1;
   my $tdir = path($config->{target_dir});
   $config->{target_dir} =~ s{::}{-}gmxs;

   my $main_module = $config->{target};
   my @other_modules = @{$config->{args}};

   my (%directories, %modules, %pods);
   for my $module ($main_module, @other_modules) {
      next if exists $modules{$module};
      (my $path = "lib/$module.pm") =~ s{::}{/}gmxs;
      my $dir = path($path)->parent;
      while ($dir ne '.') {
         $directories{$dir} = 1;
         $dir = $dir->parent;
      }
      $modules{$path} = $module;
      $path =~ s{\.pm$}{.pod}mxs;
      $pods{$path} = $module;
   }

   my %common_options = (
      distro_name => $config->{target_dir},
      main_module => $main_module,
      other_modules => \@other_modules,
      all_modules => [$main_module, @other_modules],
   );
   my (@files, @directories);
   for my $item (@{$config->{files}}) {
      my %model = %$item;
      if ($model{destination} eq '*module') {
         push @directories, map {
            {
               destination => $_,
               mode => $model{dmode},
            }
         } sort { length $a <=> length $b } keys %directories;
         push @files, map{
            {
               %model,
               destination => $_,
               opts => {
                  %{$model{opts} || {}},
                  %common_options,
                  module => $modules{$_},
                  filename => $_,
               },
            }
         } keys %modules;
      }
      elsif ($model{destination} eq '*pod') {
         push @files, map{
            {
               %model,
               destination => $_,
               opts => {
                  %{$model{opts} || {}},
                  %common_options,
                  module => $pods{$_},
                  filename => $_,
               },
            }
         } keys %pods;
      }
      else {
         $model{opts} = {%common_options, %{$model{opts} || {}}};
         if (exists $model{source}) {
            push @files, \%model;
         }
         else {
            push @directories, \%model;
         }
      };
   }

   $config->{files} = [@directories, @files];
};

1;
