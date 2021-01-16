package SKFold::Custom;
use strict;
use warnings;

sub adapt_module_configuration {
   my ($config) = @_;

   my $spec = $config->{files}[0];
   my ($target, @files);
   if ($config->{target} eq '-' || $config->{target} eq '') {
      $target = '-';
   }
   else {
      $target = path($config->{target})->absolute;
      @files = map {
         my %record = (destination => $_);
         $record{mode} = $spec->{dmode} if defined $spec->{dmode};
         \%record;
      } ancestors_for($target);
   }
   push @files, {%$spec, destination => $target};
   $config->{files} = \@files;

   $config->{target_dir} = path('/');

   return;
};

1;
