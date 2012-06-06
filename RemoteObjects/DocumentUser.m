/* 
 * DocumentUser.m
 * Vault
 *
 * Created by Jace Allison on January 10, 2012
 * Last modified on May 28, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 *
 * This file contains properties which map to JSON objects that give a Vault user's information when
 * a request is sent to Vault with a user id.
 *
 ******************************************************
 * EXAMPLE JSON RESPONSE FOR OBJECT MAPPING OF USER
 ******************************************************
 *
 * {"responseStatus":"SUCCESS",
 * "users":[{
 * "user":{
 * "user_type_id__v":null,
 * "user_title__v":null,
 * "vault_id__v":[1025],
 * "user_last_name__v":"Kreutzbender",
 * "office_phone__v":null,
 * "is_domain_admin__v":null,
 * "active__v":true,
 * "site__v":null,
 * "domain_id__v":1018,
 * "created_date__v":"2012-04-19T22:21:12.000Z",
 * "user_email__v":"Kreutzbj@onid.orst.edu",
 * "user_timezone__v":"America/Los_Angeles",
 * "id":979,
 * "user_name__v":"Kreutzbj@oregonstate.edu",
 * "user_locale__v":"en_US",
 * "user_needs_to_change_password__v":false,
 * "security_policy_id__v":157,
 * "user_first_name__v":"Jeremy",
 * "fax__v":null,
 * "created_by__v":1,
 * "modified_date__v":null,
 * "modified_by__v":1,
 * "mobile_phone__v":null}}]}
 *
 ******************************************************
 */

#import "DocumentUser.h"

@implementation DocumentUser

@synthesize firstName;          /* The first name of a Vault user */
@synthesize lastName;           /* The last name of a Vault user */

@end
