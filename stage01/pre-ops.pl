#!/usr/bin/perl

print "Running pre-ops\n";

$ec2timeout = 10;

$cmd = "runat $ec2timeout euca-add-keypair thekey | grep -v KEYPAIR > ../status/thekey.priv";
$rc = system($cmd);
if ($rc) {
    print "ERROR: failed to add keypair - '$cmd'\n";
    exit(1);
}
system("chmod 0600 ../status/thekey.priv");

$cmd = "runat $ec2timeout euca-authorize default -P tcp -p 22 -s 0.0.0.0/0";
$rc = system($cmd);
if ($rc) {
    print "ERROR: failed to authorize '$cmd'\n";
    exit(1);
}

chomp($emi = `runat $ec2timeout euca-describe-images | grep emi | grep -v windows | tail -n 1 | awk '{print \$2}'`);
if ($emi eq "") {
    print "ERROR: failed to get EMI\n";
    exit(1);
}

print "EMI:$emi\n";

chomp($ida = `runat $ec2timeout euca-run-instances $emi -k thekey | grep INSTANCE | awk '{print \$2}'`);
if ($ida =~ /i-.+/) {
    print "ran instance $ida\n";
} else {
    print "ERROR: failed to run 'runat $ec2timeout euca-run-instances $emi -k thekey | grep INSTANCE | awk '{print \$2}''\n";
    print  "$ida\n";
    exit(1);
}

$done=$count=0;
while(!$done) {
    chomp($ipa=`runat $ec2timeout euca-describe-instances $ida | grep running | grep -v '0\.0\.0\.0' | awk '{print \$4}'`);
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

#    $cmda = "runat $ec2timeout scp -o StrictHostKeyChecking=no -i netkey.priv netkey.priv root\@$ipa:";

exit 0;
