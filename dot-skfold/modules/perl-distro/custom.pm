package SKFold::Custom;
use strict;
use warnings;
use Path::Tiny;

sub adapt_module_configuration {
   my ($config) = @_;
   $config->{whatevah} = 1;
   my $tdir = path($config->{target_dir});
   $config->{target_dir} =~ s{::}{-}gmxs;

   my (%directories, %modules);
   for my $module ($config->{target}, @{$config->{args}}) {
      next if exists $modules{$module};
      (my $path = "lib/$module.pm") =~ s{::}{/}gmxs;
      my $dir = path($path)->parent;
      while ($dir ne '.') {
         $directories{$dir} = 1;
         $dir = $dir->parent;
      }
      $modules{$path} = $module;
   }

   my @files = map {
      if ($_->{destination} eq '*') {
         my %model = %$_;
         (
            map({
               {
                  destination => $_,
                  mode => $model{dmode},
               }
            } sort { length $a <=> length $b } keys %directories),
            map({
               {
                  %model,
                  destination => $_,
                  opts => {
                     %{$model{opts} || {}},
                     module => $modules{$_},
                     filename => $_,
                  },
               }
            } keys %modules)
         );
      }
      else {
         $_
      };
   } @{$config->{files}};

   $config->{files} = \@files;
};

1;
