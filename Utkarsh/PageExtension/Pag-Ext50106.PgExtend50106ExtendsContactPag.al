pageextension 50260 PgExtend50106ExtendsContactPag extends "Contact List"
{
    Editable = false;
    //InsertAllowed = false;


    layout
    {
        addlast(content)
        {
            repeater(General)
            {
                field("Division Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("Job Responsibility"; Rec."Job Responsibility")
                {
                    ApplicationArea = All;
                }
                field("Job Responsibility Description"; Rec."Job Responsibility Description")
                {
                    ApplicationArea = All;
                }
                /*field("customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }*/
                field("Ship-to Code"; Rec."Ship-to code")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                }
                field(Pricing; Rec.Pricing)
                {

                }
                field(Marketing; rec.Marketing)
                {

                }
                field("Prospect Company Name"; rec."Prospect Company Name")
                {

                }

            }
        }
    }
    actions
    {
        addlast(reporting)
        {
            action("Contact List Report")
            {
                ApplicationArea = "#RelationshipMgmt";
                RunObject = report "Rep50110_ContactReport";
                Image = Report;
            }
        }
    }
}
