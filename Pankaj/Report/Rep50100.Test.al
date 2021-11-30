report 50100 Test
{
    ApplicationArea = All;
    Caption = 'Test';
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/Test.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            column(No; "No.")
            {
            }
            column(SelltoAddress; "Sell-to Address")
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
