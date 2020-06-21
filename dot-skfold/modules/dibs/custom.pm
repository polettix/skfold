package SKFold::Custom;
use strict;
use warnings;

sub adapt_module_configuration {
   my ($config) = @_;
   my $spec = $config->{files}[0];
   my $target = path($config->{target})->absolute;
   $config->{target_dir} = path('/');

   my @files = map {
      my %record = (destination => $_);
      $record{mode} = $spec->{dmode} if defined $spec->{dmode};
      \%record;
   } ancestors_for($target);

   push @files, {%$spec, destination => $target};
   $config->{files} = \@files;
   return;
};

1;
