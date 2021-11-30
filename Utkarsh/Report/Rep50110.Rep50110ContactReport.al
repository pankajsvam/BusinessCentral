report 50252 Rep50110_ContactReport
{
    ApplicationArea = All;
    Caption = 'Contact Report';
    UsageCategory = Lists;
    DefaultLayout = RDLC;
    RDLCLayout = 'Contact Report.rdl';
    dataset
    {
        dataitem(Contact; Contact)
        {
            RequestFilterFields = Type, "Shortcut Dimension 5 Code", "Job Responsibility", "Job Responsibility Description";
            CalcFields = "Job Responsibility Description", "Ship-to Name";
            column(Type; Type)
            {
            }
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Address; Address)
            {
            }
            column(Address2; "Address 2")
            {
            }
            column(City; City)
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(TerritoryCode; "Territory Code")
            {
            }
            column(SalespersonCode; "Salesperson Code")
            {
            }
            column(EMail; "E-Mail")
            {
            }
            column(CompanyNo; "Company No.")
            {
            }
            column(CompanyName; "Company Name")
            {
            }
            column(ShortcutDimension5Code; "Shortcut Dimension 5 Code")
            {
            }
            column(JobResponsibility; "Job Responsibility")
            {
            }
            column(JobResponsibilityDescription; "Job Responsibility Description")
            {
            }
            /* column(CustomerNo; "Customer No.")
            {
            } */
            column(ShiptoCode; "Ship-to Code")
            {
            }
            column(ShiptoName; "Ship-to Name")
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
}
