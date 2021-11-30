// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50149 CustomerListExtP1 extends "Contact Card"
{
    layout
    {
        addlast(General)
        {
            field("Customer No."; Rec."Customer No.")
            {
            }
            field("Date Created"; Rec."Date Created")
            {

            }
            field("Created By"; rec."Created By")
            {

            }
            field("Blocked Customer"; rec."Blocked Customer")
            {

            }
        }
        addlast(General)
        {
            field("Division Code"; Rec."Shortcut Dimension 5 Code")
            {

                ApplicationArea = All;
            }

            field("Job Responsibility Description"; Rec."Job Responsibility Description")
            {

            }
            /* field("Customer No."; Rec."Customer No.")
            {

            } */
            field("Ship-to Code"; Rec."Ship-to Code")
            {

            }
            field("Ship-to Name"; Rec."Ship-to Name")
            {

            }
            field("Prospect Company Name"; Rec."Prospect Company Name")
            {

            }
            field(Pricing; Rec.Pricing)
            {

            }
            field(Marketing; Rec.Marketing)
            {

            }

        }
    }

}