package SKFold::Custom;
use strict;
use warnings;
use Path::Tiny;

sub adapt_module_configuration {
   my ($config) = @_;
   my @files = map {
      if ($_->{destination} eq '*') {
         +{ %$_, destination => $config->{target} };
      }
      else {
         $_
      };
   } @{$config->{files}};
   $config->{files} = \@files;
   $config->{opts}{target} = $config->{target};
};

1;
