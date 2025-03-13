#!/usr/bin/perl
use strict;
use warnings;
use Quota;

# Define the filesystem and users with their new quotas
my $filesystem = '/dev/sda5';
my %user_quotas = (
    'manolito' => { blocks_soft => 2000, blocks_hard => 2200, inodes_soft => 50, inodes_hard => 60 },
    'manolita' => { blocks_soft => 1500, blocks_hard => 1700, inodes_soft => 40, inodes_hard => 50 },
    # Add more users as needed
);

# Iterate over each user and set their quotas
foreach my $user (keys %user_quotas) {
    my $uid = getpwnam($user);
    if (defined $uid) {
        my $blocks_soft = $user_quotas{$user}->{blocks_soft};
        my $blocks_hard = $user_quotas{$user}->{blocks_hard};
        my $inodes_soft = $user_quotas{$user}->{inodes_soft};
        my $inodes_hard = $user_quotas{$user}->{inodes_hard};

        # Set the quotas
        Quota::setqlim($filesystem, $uid, $blocks_soft, $blocks_hard, $inodes_soft, $inodes_hard, 0)
            or warn "Failed to set quota for $user: " . Quota::strerr() . "\n";
    } else {
        warn "User $user does not exist\n";
    }
}

print "Quotas updated successfully.\n";