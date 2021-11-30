page 50149 "Contact Management"
{
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(YearVar; YearVar)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Year';

                    trigger OnValidate()
                    begin

                        CurrPage."Total Contacts".PAGE.SetOptionChoice(FORMAT(YearVar));
                        CurrPage."Total Contact by Job".PAGE.SetOptionChoice(FORMAT(YearVar));
                        CurrPage."Total Prospects".PAGE.SetOptionChoice(FORMAT(YearVar));
                        CurrPage."Total Prospect by Job".PAGE.SetOptionChoice(FORMAT(YearVar));
                        CurrPage.UPDATE(FALSE);

                    end;
                }

                field(DateVar; DateVar)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Date';

                }
            }
            part("Total Contacts"; "Total Contacts")
            {

            }
            part("Total Contact by Job"; "Total Contact by Job")
            {

            }
            part("Total Prospects"; "Total Prospects")
            {

            }
            part("Total Prospect by Job"; "Total Prospect by Job")
            {

            }

        }
    }
    actions
    {
        // Adds the action called "My Actions" to the Action menu 
        area(Processing)
        {
            action("Referesh Data")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = RefreshLines;
                trigger OnAction()
                begin
                    ContactMgmtVar.Run();
                end;
            }
            action("Export Data")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = RefreshLines;
                trigger OnAction()
                begin
                    Message('Exported');
                end;
            }
            action("Import Data")
            {
                trigger OnAction();
                begin
                    Xmlport.Run(50149, true, true);
                end;
            }
        }
    }
    trigger OnOpenPage();
    begin
        YearVar := YearVarEnum::"2021";
        DateVar := Today;
        CurrPage."Total Contacts".PAGE.SetOptionChoice(FORMAT(YearVar));
        CurrPage."Total Contact by Job".PAGE.SetOptionChoice(FORMAT(YearVar));
        CurrPage."Total Prospects".PAGE.SetOptionChoice(FORMAT(YearVar));
        CurrPage."Total Prospect by Job".PAGE.SetOptionChoice(FORMAT(YearVar));
    end;

    var
        YearVar: Enum YearVarEnum;
        DateVar: Date;
        ContactMgmtVar: CodeUnit "Contact Management";
}
