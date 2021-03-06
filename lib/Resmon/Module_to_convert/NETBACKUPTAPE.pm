package Resmon::Module::NETBACKUPTAPE;
use Resmon::ExtComm qw/cache_command/;
use Resmon::Module;
use vars qw/@ISA/;
@ISA = qw/Resmon::Module/;

sub handler {
  my $arg = shift;
  my $unit = $arg->{'object'};
  my $output = cache_command("/usr/openv/volmgr/bin/vmoprcmd -d ds", 500);
  my $down = 0;
  my $up = 0;
  foreach my $line (split(/\n/, $output)) {
    if ($line =~ /^\s*(\d+)\s+\S+\s+(\S+)/) {
      my $tape = $1;
      if($2 =~ /DOWN/) { $down++; }
      else { $up++; }
    }
  }
  if($down || !$up) {
    return "BAD($up UP, $down DOWN)\n";
  }
  return "OK($up UP)\n";
};
1;
