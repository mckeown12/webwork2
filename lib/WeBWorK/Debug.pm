################################################################################
# WeBWorK Online Homework Delivery System
# Copyright � 2000-2003 The WeBWorK Project, http://openwebwork.sf.net/
# $CVSHeader: webwork-modperl/lib/WeBWorK/Timing.pm,v 1.9 2004/05/13 18:28:42 gage Exp $
# 
# This program is free software; you can redistribute it and/or modify it under
# the terms of either: (a) the GNU General Public License as published by the
# Free Software Foundation; either version 2, or (at your option) any later
# version, or (b) the "Artistic License" which comes with this package.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See either the GNU General Public License or the
# Artistic License for more details.
################################################################################

package WeBWorK::Debug;
use base qw(Exporter);
our @EXPORT = qw(debug);

=head1 NAME

WeBWorK::Debug - Print (or don't print) debugging output.

head1 SYNOPSIS

 use WeBWorK::Debug;
 
 # Enable debugging
 $WeBWorK::Debug::Enabled = 1;
 
 # Log to a file instead of STDERR
 $WeBWorK::Debug::Logfile = "/path/to/debug.log";
 
 # log some debugging output
 debug("Generated 5 widgets.");

=cut

use strict;
use warnings;

################################################################################

=head1 CONFIGURATION VARIABLES

=over

=item $Enabled

If true, debugging messages will be output. If false, they will be ignored.

=cut

our $Enabled = 0 unless defined $Enabled;

=item $Logfile

If non-empty, debugging output will be sent to the file named rather than STDERR.

=cut

our $Logfile = "" unless defined $Logfile;

=back

=cut

################################################################################

=head1 FUNCTIONS

=over

=item debug(@messages)

Write @messages to the debugging log.

=cut

sub debug {
	my (@message) = @_;
	
	if ($Enabled) {
		my ($package, $filename, $line, $subroutine) = caller(1);
		my $finalMessage = "$subroutine: " . join("", @message);
		$finalMessage .= "\n" unless $finalMessage =~ m/\n$/;
		
		if ($WeBWorK::Debug::Logfile ne "") {
			if (open my $fh, ">>", $Logfile) {
				print $fh $finalMessage;
				close $fh;
			} else {
				warn "Failed to open debug log '$Logfile' in append mode: $!";
				print STDERR $finalMessage;
			}
		} else {
			print STDERR $finalMessage;
		}
	}
}

=back

=cut

################################################################################

=head1 AUTHOR

Written by Sam Hathaway, sh002i (at) math.rochester.edu.

=cut

1;