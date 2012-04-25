#!/usr/bin/perl

print "Running post-fail-ops\n";

$ec2timeout = 10;

$done=$count=0;
while(!$done) {
    chomp($ipa=`runat $ec2timeout euca-describe-instances | grep running | grep -v '0\.0\.0\.0' | awk '{print \$4}' | tail -n 1`);
    if (($ipa =~ /\d+.\d+.\d+.\d+/) || $count > 600) {
	$done++;
    }
    $count++;
}
if (!$ipa) {
    print "ERROR: could not get public ip for running instance $ida\n";
    system("runat $ec2timeout euca-describe-instances");
    exit(1);
}

if (-f "../status/thekey.priv") {
    $cmd = "runat $ec2timeout ssh -o StrictHostKeyChecking=no -i ../status/thekey.priv root\@$ipa uname -a";
    print "RUNNING CMD: '$cmd'\n";
    $rc = system("$cmd");
} else {
    print "ERROR: could not find '../status/thekey.priv' from previous step\n";
    $rc = 1;
}

exit $rc;
