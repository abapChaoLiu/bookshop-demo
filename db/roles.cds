namespace my.bookshop;

using {
  managed,
  cuid,
  User
} from '@sap/cds/common';

type BusinessObject : String(255);

entity Roles : cuid, managed {
  @mandatory
  rolename        : localized String(255) not null @(title : '{i18n>RoleName}', );
  description     : localized String not null      @(title : '{i18n>Description}', );
  read            : Boolean                        @(title : '{i18n>Read}', );
  authcreate      : Boolean                        @(title : '{i18n>Create}', );
  authupdate      : Boolean                        @(title : '{i18n>Update}', );
  approve         : Boolean                        @(title : '{i18n>Approve}', );
  validFrom       : Timestamp                      @(title : '{i18n>validFrom}', );
  validTo         : Timestamp                      @(title : '{i18n>validTo}', );
  BusinessObjects : Composition of many Role_BusinessObject
                      on BusinessObjects.parent = $self;
  Users           : Composition of many Role_User
                      on Users.parent = $self;
};

annotate Roles with @fiori.draft.enabled;

entity BusinessObjects {
  key ID       : BusinessObject;
      parent   : Association to BusinessObjects;
      children : Composition of many BusinessObjects
                   on children.parent = $self;
};

entity Role_BusinessObject : cuid {
  parent         : Association to Roles;
  BusinessObject : BusinessObject;
};

entity Role_User : cuid {
  parent    : Association to Roles;
  user      : User;
  @(title : '{i18n>requester', )
  requester : Employee;
};

entity Users : managed {
  key username    : String    @(title : '{i18n>Username}', );
      employee    : Employee;
      responsible : Employee;
      validFrom   : Timestamp @(title : '{i18n>validFrom}', );
      validTo     : Timestamp @(title : '{i18n>validTo}', );
      address     : Composition of Address
                      on address.parent = $self;
      roles       : Association to many Role_User
                      on roles.user = $self.username;
};

entity Address : cuid, managed {
  parent : Association to Users;
  street : String(60) @(title : '{i18n>Street}', );
  city   : String(60) @(title : '{i18n>City}', );
};

type XSUAAUsers {
  id         : String;
  externalId : String;
  userName   : String;
}

@cds.autoexpose
@UI.Identification : [{Value : email}]
@cds.odata.valuelist
entity Employees : cuid {
  @(title : '{i18n>BusinessPartnerFirstName}')
  firstName  : String;
  @(title : '{i18n>BusinessPartnerName}')
  lastName   : String;
  @(title : '{i18n>BusinessPartnerCompany}')
  company    : String;
  @(title : '{i18n>BusinessPartnerDepartment}')
  department : String;
  @(title : '{i18n>BusinessPartnerEmailAddress}')
  @mandatory
  email      : String not null;
}

type Employee       : Association to Employees;
annotate Employees with @UI.Identification : [{Value : email}, ];
annotate Employees with @cds.odata.valuelist;

annotate Employees with {
  @Common.Text : {
    $value              : email,
    @UI.TextArrangement : #TextOnly
  }
  @(title : '{i18n>EmployeeID}')
  ID;
};
