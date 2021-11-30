page 50258 "Contact Feeder Header"
{

    Caption = 'Contact Feeder Header';
    PageType = Document;
    SourceTable = "Contact Feeder Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.';
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    ApplicationArea = All;
                }
                field("Customer Name 2"; Rec."Customer Name 2")
                {
                    ToolTip = 'Specifies the value of the Customer Name 2 field.';
                    ApplicationArea = All;
                }
                field("Customer Address"; Rec."Customer Address")
                {
                    ToolTip = 'Specifies the value of the Customer Address field.';
                    ApplicationArea = All;
                }
                field("Customer Address 2"; Rec."Customer Address 2")
                {
                    ToolTip = 'Specifies the value of the Customer Address 2 field.';
                    ApplicationArea = All;
                }
                field("Customer City"; Rec."Customer City")
                {
                    ToolTip = 'Specifies the value of the Customer City field.';
                    ApplicationArea = All;
                }
                field("Customer County"; Rec."Customer County")
                {
                    ToolTip = 'Specifies the value of the Customer County field.';
                    ApplicationArea = All;
                }
                field("Customer Post Code"; Rec."Customer Post Code")
                {
                    ToolTip = 'Specifies the value of the Customer Post Code field.';
                    ApplicationArea = All;
                }
                field("RSM Code"; Rec."RSM Code")
                {
                    ToolTip = 'Specifies the value of the RSM Code field.';
                    ApplicationArea = All;
                }
                field("ISR Code"; Rec."ISR Code")
                {
                    ToolTip = 'Specifies the value of the ISR Code field.';
                    ApplicationArea = All;
                }
                field("OSR Code"; Rec."OSR Code")
                {
                    ToolTip = 'Specifies the value of the OSR Code field.';
                    ApplicationArea = All;
                }
                field("CSR Code"; Rec."CSR Code")
                {
                    ToolTip = 'Specifies the value of the CSR Code field.';
                    ApplicationArea = All;
                }


            }
            part("Contact feeder Lines"; "50256")
            {
                SubPageLink = "Entry No." = FIELD("Entry No.");

            }

        }
    }

}
