xmlport 50262 XML50111_UploadCustContFeeder
{
    Caption = 'Upload Customer Contact Feeder';
    Format = VariableText;



    schema
    {
        textelement(RootNodeName)
        {
            tableelement(Integer; "Integer")
            {
                AutoSave = false;
                AutoReplace = true;
                trigger OnPreXmlItem()
                begin
                    FirstLine := TRUE;

                    ContactFeederHeader.RESET;
                    IF ContactFeederHeader.FIND('+') THEN
                        EntryNo := ContactFeederHeader."Entry No.";

                    ContactFeederHeader.RESET
                end;

                trigger OnBeforeModifyRecord()
                begin
                    IF FirstLine THEN BEGIN
                        FirstLine := FALSE;
                        currXMLport.SKIP;
                    END;

                    EVALUATE(Priceing1, Pricing); //<TPZ3226>
                    EVALUATE(Marketing1, Marketing); //<TPZ3226>

                    EntryNo := EntryNo + 1;
                    ContactFeederHeader.INIT;
                    ContactFeederHeader."Entry No." := EntryNo;
                    ContactFeederHeader."Line No." := 0;
                    ContactFeederHeader.Type := ContactFeederHeader.Type::Customer;
                    ContactFeederHeader.VALIDATE("Customer No.", CustAccount);
                    ContactFeederHeader.VALIDATE("Shortcut Dimension 5 Code", DivCode);
                    ContactFeederHeader.VALIDATE("Ship-to Code", ShipToCode);
                    ContactFeederHeader."Job Responsibility" := JobResp;
                    ContactFeederHeader."E-Mail Address" := EmailAddress;
                    ContactFeederHeader."First Name" := FirstName;
                    ContactFeederHeader."Last Name" := LastName;
                    ContactFeederHeader."Phone Number" := PhoneNo;
                    ContactFeederHeader.Pricing := Priceing1;
                    ContactFeederHeader.Marketing := Marketing1;
                    ContactFeederHeader.INSERT(TRUE);
                end;


            }
            textelement(DivCode)
            {

            }
            textelement(CustAccount)
            {

            }
            textelement(ShipToCode)
            {

            }
            textelement(JobResp)
            {

            }
            textelement(EmailAddress)
            {

            }
            textelement(FirstName)
            {

            }
            textelement(LastName)
            {

            }
            textelement(PhoneNo)
            {

            }
            textelement(Pricing)
            {

            }
            textelement(Marketing)
            {

            }

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

    trigger OnPostXmlPort()
    begin
        MESSAGE('Successfully Uploaded');
    end;

    var
        ContactFeederHeader: Record "Contact Feeder Entry";
        EntryNo: Integer;
        JobResponsibility: Record "Job Responsibility";
        FirstLine: Boolean;
        Priceing1: Boolean;
        Marketing1: Boolean;
}
