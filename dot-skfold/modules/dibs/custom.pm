package SKFold::Custom;
use strict;
use warnings;

sub adapt_module_configuration {
   my ($config) = @_;

   return _templates_list($config) if $config->{opts}{templates};

   my $source = $config->{opts}{template};
   main::LOGDIE "select one template with -t (call with -T for list)"
      unless defined $source;

   my $spec = $config->{files}[0];
   my ($target, @files);
   if ($config->{target} eq '-') {
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
   push @files, {%$spec, destination => $target, source => $source};
   $config->{files} = \@files;

   $config->{target_dir} = path('/');

   return;
};

sub _templates_list {
   my $config = shift;
   my $list = join "\n",
      grep {! /^\./}
      map {$_->basename}
      $config->{templates_dir}->children;
   $list .= "\n";
   $config->{files} =[
      {
         source => sub { return $list },
         destination => '-',
      }
   ];
}

1;
