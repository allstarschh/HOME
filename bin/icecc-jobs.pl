#!/usr/bin/env perl

# This short script queries the icecream scheduler to discover what machines are connected,
# and sums the maximum job counts for all x86-64 machines.
# It can be used in your mozconfig as follows:
#   mk_add_options MOZ_MAKE_FLAGS="-j$(icecc-jobs)"
# if this script is on your PATH, and named icecc-jobs

use List::Util qw(sum0);

#my $scheduler = "10.242.24.68";
my $scheduler = "10.238.25.186";

# Get the local processor count
if ($^O eq "darwin") {
    $locl = `sysctl -n hw.ncpu`;
    $xtra = $locl; # darwin machines are not included in the scheduler count
} else {
    $locl = `nproc`;
    $xtra = 0; # We're on linux, and will be included in the scheduler count
}

# Set up a signal to print out a default value if the query takes too long
$SIG{ALRM} = sub { print $locl; exit 0; };
alarm(2);

# Run the query, and print out the sum of the maximum job counts
my $resp = `nc $scheduler 8766 <<EOF
listcs
exit
EOF`;
print sum0($resp =~ /\[x86_64\].+jobs=[0-9]+\/([0-9]+)/g) + $xtra;
