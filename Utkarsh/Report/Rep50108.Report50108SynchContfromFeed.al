report 50254 "Report50108_SynchContfromFeed "
{
    ApplicationArea = All;
    Caption = 'Synch Contact from Feeder ';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Contact Feeder Entry"; "Contact Feeder Entry")
        {
            DataItemTableView = SORTING("Entry No.", "Line No.")
                                 WHERE("Job Responsibility" = FILTER(<> ''));
            RequestFilterFields = "Entry No.";
            trigger OnPreDataItem()
            begin
                SETFILTER(Synched, 'FALSE');
            end;

            trigger OnAfterGetRecord()
            begin
                EmailFoundinCust := FALSE;
                EmailFoundinPros := FALSE;
                EmailFound := FALSE;


                IF "Shortcut Dimension 5 Code" = '' THEN
                    CurrReport.SKIP;

                Pos := 0;
                IF Type = Type::Prospect THEN BEGIN
                    Pos := STRPOS("Job Responsibility", 'Prospect');
                    IF Pos = 0 THEN
                        Pos := STRPOS("Job Responsibility", 'PROSPECT');
                    IF Pos = 0 THEN
                        CurrReport.SKIP;
                END;

                // IF "E-Mail Address" <> '' THEN
                //   EmailCheck;

                IF EmailFound = FALSE THEN BEGIN
                    RMSetup.GET;
                    RMSetup.TESTFIELD(RMSetup."Contact Nos.");
                    IF (Type = Type::Customer) THEN BEGIN
                        ContactBusinessRelation.RESET;
                        ContactBusinessRelation.SETRANGE(ContactBusinessRelation."Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                        ContactBusinessRelation.SETRANGE(ContactBusinessRelation."No.", "Customer No.");
                        IF NOT ContactBusinessRelation.FINDFIRST THEN BEGIN
                            IF Customer.GET("Customer No.") THEN;
                            ContactCompany.INIT;
                            ContactCompany."No." := NoSeriesMgmt.GetNextNo(RMSetup."Contact Nos.", TODAY, TRUE);
                            ContactCompany.INSERT(TRUE);
                            ContactCompany.VALIDATE(ContactCompany.Name, Customer.Name);
                            ContactCompany.Address := Customer.Address;
                            ContactCompany."Address 2" := Customer."Address 2";
                            ContactCompany.VALIDATE(ContactCompany.City, Customer.City);
                            ContactCompany."Phone No." := Customer."Phone No.";
                            ContactCompany.VALIDATE(ContactCompany."Country/Region Code", Customer."Country/Region Code");
                            ContactCompany.VALIDATE(ContactCompany."Post Code", Customer."Post Code");
                            ContactCompany.VALIDATE(ContactCompany.County, Customer.County);
                            ContactCompany.VALIDATE(ContactCompany."E-Mail", Customer."E-Mail");
                            ContactCompany."Home Page" := Customer."Home Page";
                            ContactCompany."No. Series" := RMSetup."Contact Nos.";
                            ContactCompany.VALIDATE(ContactCompany.Type, ContactCompany.Type::Company);
                            ContactCompany.VALIDATE(ContactCompany."Company No.", ContactCompany."No.");
                            ContactCompany."Company Name" := Customer.Name;
                            ContactCompany."Shortcut Dimension 5 Code" := "Shortcut Dimension 5 Code";
                            ContactCompany."Ship-to Code" := "Ship-to Code";
                            ContactCompany.Marketing := Marketing;
                            ContactCompany.Pricing := Pricing;
                            ContactCompany.MODIFY(TRUE);

                            ContactBusinessRelation.INIT;
                            ContactBusinessRelation."Contact No." := ContactCompany."No.";
                            ContactBusinessRelation.VALIDATE(ContactBusinessRelation."Business Relation Code", '1');
                            ContactBusinessRelation."Link to Table" := ContactBusinessRelation."Link to Table"::Customer;
                            ContactBusinessRelation."No." := "Customer No.";
                            ContactBusinessRelation.INSERT(TRUE);

                            CompanyNo := ContactCompany."No.";
                        END ELSE BEGIN
                            CompanyNo := ContactBusinessRelation."Contact No.";
                        END;
                    END;


                    Contact.INIT;
                    Contact."No." := NoSeriesMgmt.GetNextNo(RMSetup."Contact Nos.", TODAY, TRUE);
                    Contact.INSERT(TRUE);
                    Contact.VALIDATE(Contact.Name, "First Name" + ' ' + "Last Name");
                    Contact.Address := Address;
                    Contact."Address 2" := "Address 2";
                    Contact.VALIDATE(Contact.City, City);
                    Contact."Phone No." := "Phone Number";
                    Contact.VALIDATE(Contact."Country/Region Code", "Country/Region Code");
                    Contact.VALIDATE(Contact."Post Code", "Post Code");
                    Contact.VALIDATE(Contact.County, County);
                    Contact.VALIDATE(Contact."E-Mail", "E-Mail Address");
                    Contact."No. Series" := RMSetup."Contact Nos.";
                    Contact."First Name" := "First Name";
                    Contact.Surname := "Last Name";
                    Contact."Job Title" := "Job Title";
                    Contact."Mobile Phone No." := "Mobie Phone Number";
                    Contact."Ship-to Code" := "Ship-to Code";
                    Contact.Marketing := Marketing;
                    Contact.Pricing := Pricing;

                    JobResponsibility.RESET;
                    JobResponsibility.SETRANGE(JobResponsibility.Description, "Job Responsibility");
                    IF JobResponsibility.FINDFIRST THEN;

                    Contact."Shortcut Dimension 5 Code" := "Shortcut Dimension 5 Code";

                    ContactJobResponsibility.RESET;
                    ContactJobResponsibility.INIT;
                    ContactJobResponsibility."Contact No." := Contact."No.";
                    ContactJobResponsibility."Job Responsibility Code" := JobResponsibility.Code;
                    ContactJobResponsibility."Job Responsibility Description" := JobResponsibility.Description;
                    ContactJobResponsibility.INSERT(TRUE);


                    Contact.VALIDATE(Contact.Type, Contact.Type::Person);

                    IF (Type = Type::Customer) THEN BEGIN
                        Contact.VALIDATE(Contact."Company No.", CompanyNo);
                        Contact."Company Name" := "Customer Name";
                        Contact."Lookup Contact No." := Contact."No.";
                    END ELSE BEGIN
                        Contact."Company No." := '';
                        Contact."Company Name" := '';
                        Contact."Prospect Company Name" := "Prospect Company Name";
                        Contact."Lookup Contact No." := '';
                    END;

                    Contact.MODIFY(TRUE);

                    Synched := TRUE;
                    "Contact No." := Contact."No.";
                    MODIFY;
                END ELSE BEGIN
                    IF EmailFoundinCust THEN
                        "Email Exist as Customer" := TRUE;
                    IF EmailFoundinPros THEN
                        "Email Exist as Prospect" := TRUE;
                    MODIFY;
                END;


            end;

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    VAR
        Contact: Record 5050;
        ContactBusinessRelation: Record 5054;
        ContactCompany: Record 5050;
        NoSeriesMgmt: Codeunit 396;
        RMSetup: Record 5079;
        ContactJobResponsibility: Record 5067;
        JobResponsibility: Record 5066;
        Customer: Record 18;
        CompanyNo: Code[30];
        //SmtpMail : Record 409;
        //Smtp : Codeunit 400;
        //SyncReport : Report 51079;
        SyncPath: Text;
        //filemgmt : Codeunit 419;
        Recipients: Text[1024];
        // WHReports : Codeunit 51007;
        EmailFoundinCust: Boolean;
        EmailFoundinPros: Boolean;
        EmailFound: Boolean;
        JObRes: Text;
        JobResponsibility1: Record 5066;
        Pos: Integer;

    PROCEDURE EmailCheck();
    VAR
        ContactEmaiCheck: Record 5050;
    BEGIN

        IF "Contact Feeder Entry".Type = "Contact Feeder Entry".Type::Customer THEN BEGIN
            ContactEmaiCheck.RESET;
            ContactEmaiCheck.SETRANGE(ContactEmaiCheck."Shortcut Dimension 5 Code", "Contact Feeder Entry"."Shortcut Dimension 5 Code");
            ContactEmaiCheck.SETRANGE("E-Mail", "Contact Feeder Entry"."E-Mail Address");
            IF ContactEmaiCheck.FINDFIRST THEN BEGIN
                EmailFound := TRUE;
                EmailFoundinCust := TRUE
            END;
        END ELSE BEGIN
            ContactEmaiCheck.RESET;
            ContactEmaiCheck.SETRANGE(Type, ContactEmaiCheck.Type::Person);
            ContactEmaiCheck.SETRANGE(ContactEmaiCheck."Shortcut Dimension 5 Code", "Contact Feeder Entry"."Shortcut Dimension 5 Code");
            ContactEmaiCheck.SETRANGE("E-Mail", "Contact Feeder Entry"."E-Mail Address");
            IF ContactEmaiCheck.FINDFIRST THEN BEGIN
                EmailFound := TRUE;
                EmailFoundinPros := TRUE;
            END;

        END;

    END;
}
