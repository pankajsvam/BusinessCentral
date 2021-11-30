report 50253 Rep50109_SynchContFeederExcept
{
    ApplicationArea = All;
    Caption = 'Sync Contact Feeder Except';
    UsageCategory = Lists;
    DefaultLayout = RDLC;
    RDLCLayout = 'Sync Cont Feeder Exception.rdl';
    dataset
    {
        dataitem("Contact Feeder Entry"; "Contact Feeder Entry")
        {
            DataItemTableView = SORTING("Entry No.", "Line No.");
            column(Address; Address)
            {
            }
            column(Address2; "Address 2")
            {
            }
            column(CSRCode; "CSR Code")
            {
            }
            column(City; City)
            {
            }
            column(ContactNo; "Contact No.")
            {
            }
            column(CountryRegionCode; "Country/Region Code")
            {
            }
            column(County; County)
            {
            }
            column(CustomerAddress; "Customer Address")
            {
            }
            column(CustomerAddress2; "Customer Address 2")
            {
            }
            column(CustomerCity; "Customer City")
            {
            }
            column(CustomerContact; "Customer Contact")
            {
            }
            column(CustomerCounty; "Customer County")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(CustomerName2; "Customer Name 2")
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(CustomerPostCode; "Customer Post Code")
            {
            }
            column(DateCreated; "Date Created")
            {
            }
            column(EMailAddress; "E-Mail Address")
            {
            }
            column(EmailExistasCustomer; "Email Exist as Customer")
            {
            }
            column(EmailExistasProspect; "Email Exist as Prospect")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(FirstName; "First Name")
            {
            }
            column(ISRCode; "ISR Code")
            {
            }
            column(JobResponsibility; "Job Responsibility")
            {
            }
            column(JobTitle; "Job Title")
            {
            }
            column(LastName; "Last Name")
            {
            }
            column(LineNo; "Line No.")
            {
            }
            column(Marketing; Marketing)
            {
            }
            column(MobiePhoneNumber; "Mobie Phone Number")
            {
            }
            column(OSRCode; "OSR Code")
            {
            }
            column(PhoneNumber; "Phone Number")
            {
            }
            column(PostCode; "Post Code")
            {
            }
            column(Pricing; Pricing)
            {
            }
            column(ProspectCompanyName; "Prospect Company Name")
            {
            }
            column(RSMCode; "RSM Code")
            {
            }
            column(SelltoCountryRegionCode; "Sell-to Country/Region Code")
            {
            }
            column(ShiptoCode; "Ship-to Code")
            {
            }
            column(ShiptoName; "Ship-to Name")
            {
            }
            column(ShortcutDimension5Code; "Shortcut Dimension 5 Code")
            {
            }
            column(Synched; Synched)
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(Type; "Type")
            {
            }
            column(UserID; "User ID")
            {
            }
            column(JobResRemark; JobResRemark)
            {
            }
            trigger OnAfterGetRecord()
            begin
                IF ("Contact Feeder Entry".Synched = FALSE) AND ("Contact Feeder Entry".Type = "Contact Feeder Entry".Type::Customer)
                    AND ("Contact Feeder Entry"."Customer No." = '') AND ("Contact Feeder Entry"."Customer Name" = '')
                    AND ("Contact Feeder Entry"."Job Responsibility" = '') THEN
                    CurrReport.SKIP;

                JobResRemark := '';
                IF "Contact Feeder Entry".Synched = FALSE THEN BEGIN
                    IF "Contact Feeder Entry"."Job Responsibility" = '' THEN BEGIN
                        JobResRemark := Text50001;
                    END ELSE
                        IF "Contact Feeder Entry"."Email Exist as Customer" = TRUE THEN BEGIN
                            JobResRemark := 'Customer Email Already Exists';
                        END ELSE
                            IF "Contact Feeder Entry"."Email Exist as Prospect" = TRUE THEN BEGIN
                                JobResRemark := 'Prospect Email Already Exists';
                            END ELSE
                                IF "Contact Feeder Entry"."Shortcut Dimension 5 Code" = '' THEN BEGIN
                                    JobResRemark := Text50003;
                                END ELSE
                                    IF "Contact Feeder Entry".Type = "Contact Feeder Entry".Type::Prospect THEN BEGIN //UTK 3170
                                        Pos := 0;
                                        IF "Contact Feeder Entry".Type = "Contact Feeder Entry".Type::Prospect THEN BEGIN
                                            Pos := STRPOS("Contact Feeder Entry"."Job Responsibility", 'Prospect');
                                            IF Pos = 0 THEN
                                                JobResRemark := Text50004;
                                        END;
                                    END ELSE
                                        JobResRemark := '';
                END;


                IF "Contact Feeder Entry".Synched = TRUE THEN BEGIN
                    IF NOT ("Contact Feeder Entry"."Date Created" IN [TODAY - 1 .. TODAY]) THEN
                        CurrReport.SKIP;
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
    var
        JobResRemark: Text[100];
        Pos: Integer;

        Text50001: TextConst ENU = 'Contact Feeder Entry record has blank Job Responsibility and no contact was created.';
        Text50002: TextConst ENU = 'Contact Feeder Entry record has blank First Name and no contact was created.';
        Text50003: TextConst ENU = 'Customer - Contact Feeder Entry record has blank Division Code and no contact was created.';
        Text50004: TextConst ENU = 'Prospects must have job responsibility of Prospect, no contact was created.';
}
