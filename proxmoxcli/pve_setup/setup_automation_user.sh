# Create group and assign access
pveum group add automation -comment "automation"
pveum acl modify / -group automation -role PVEVMAdmin

# Create user, add to group
pveum useradd automation@pam --comment "New Automation User"
pveum user modify automation@pam -group automation

# Create token - never expire and use user permissions. Export token to file so it can be caputured later
pveum user token add automation@pam my-api-token --privsep 0 --expire 0 >> token