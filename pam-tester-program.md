1) yum install pam-devel 

2) Create file - authtest.c with following contents: Source : http://www.linux-pam.org/Linux-PAM-html/adg-example.html 

```
/* 
This program was contributed by Shane Watts 
[modifications by AGM and kukuk] 

You need to add the following (or equivalent) to the 
/etc/pam.d/check_user file: 
# check authorization 
auth required pam_unix.so 
account required pam_unix.so 
*/ 

#include <security/pam_appl.h> 
#include <security/pam_misc.h> 
#include <stdio.h> 

static struct pam_conv conv = { 
misc_conv, 
NULL 
}; 

int main(int argc, char *argv[]) 
{ 
pam_handle_t *pamh=NULL; 
int retval; 
const char *user="nobody"; 
const char *profile="sudo"; 
if(argc == 3) { 
profile = argv[1]; 
user = argv[2]; 
} 

if(argc > 3) { 
fprintf(stderr, "Usage: authtest [profile] [username]\n"); 
exit(1); 
} 

retval = pam_start(profile, user, &conv, &pamh); 

if (retval == PAM_SUCCESS) 
retval = pam_authenticate(pamh, 0); /* is user really user? */ 

if (retval == PAM_SUCCESS) 
retval = pam_acct_mgmt(pamh, 0); /* permitted access? */ 

/* This is where we have been authorized or not. */ 

if (retval == PAM_SUCCESS) { 
fprintf(stdout, "Authenticated\n"); 
} else { 
fprintf(stdout, "Not Authenticated\n"); 
} 

if (pam_end(pamh,retval) != PAM_SUCCESS) { /* close Linux-PAM */ 
pamh = NULL; 
fprintf(stderr, "check_user: failed to release authenticator\n"); 
exit(1); 
} 

return ( retval == PAM_SUCCESS ? 0:1 ); /* indicate success */ 
} 
```
3) Compile cc authtest.c -o authtest -lpam -lpam_misc 


4) Run the program with parameter <profile> <user>. It will prompt for password. Run it as application user and pass profile, admin user as an argument. 

./authtest sudo mapr 
