#!/usr/bin/env perl
# vim: ts=3 sts=3 sw=3 et ai :
# [% target %] - [% abstract %]
use 5.024;
use warnings;
use experimental qw< postderef signatures >;
no warnings qw< experimental::postderef experimental::signatures >;
use autodie;
use Pod::Usage qw< pod2usage >;
use Getopt::Long qw< GetOptionsFromArray :config gnu_getopt >;
use English qw< -no_match_vars >;
my $VERSION = '[% version %]';

my $config = get_options(
   [
      'example|e!',
      {
         optnames => 'what|ever|e=s'.
         default => 'yadda yadda yadda',
         environment => 'WHATEVER_x',
      }
   ],
   [@ARGV],
);

sub get_options ($specs, $ARGV) {
   my (%cmdline, %environment, %default);
   my @cmdline_options = qw< help! man! usage! version! >;
   for my $spec ($specs->@*) {
      my ($optnames, $default, $env_var) =
        ref $spec
        ? $spec->{qw< optnames default environment >}
        : ($spec, undef, undef);
      push @cmdline_options, $optnames;
      my $name = $optnames =~ s{[^\w-].*}{}mxs;
      $default{$name}     = $default       if defined $default;
      $environment{$name} = $ENV{$env_var} if defined $env_var;
   } ## end for my $spec ($specs->@*)

   my %cmdline;
   GetOptionsFromArray($ARGV, \%cmdline, @cmdline_options)
     or pod2usage(-verbose => 99, -sections => 'USAGE');

   pod2usage(message => "$0 $VERSION", -verbose => 99, -sections => ' ')
     if $cmdline{version};
   pod2usage(-verbose => 99, -sections => 'USAGE') if $cmdline{usage};
   pod2usage(-verbose => 99, -sections => 'USAGE|EXAMPLES|OPTIONS')
     if $cmdline{help};
   pod2usage(-verbose => 2) if $cmdline{man};

   return {%default, %environment, %cmdline};
} ## end sub get_options

__END__

=pod

=encoding utf-8

=head1 NAME

[% target %] - [% abstract %]

=head1 VERSION

The version can be retrieved with option C<--version>:

   $ [% target %] --version

=head1 USAGE

   [% target %] [--help] [--man] [--usage] [--version]

   [% target %]

=head1 EXAMPLES

   # Some examples will help...

=head1 DESCRIPTION

=head1 OPTIONS

=over

=item B<--help>

print out some help and exit.

=item B<--man>

show the manual page for [% target %].

=item B<--usage>

show usage instructions.

=item B<--version>

show version.

=back

=head1 CONFIGURATION

=head1 DIAGNOSTICS

=head1 DEPENDENCIES

=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests through the repository at
L<>.

=head1 AUTHOR

[% author %]

=head1 LICENSE AND COPYRIGHT

Copyright [% year %] by [% author %] ([% email %]).

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

or look for file C<LICENSE> in this project's root directory.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut
