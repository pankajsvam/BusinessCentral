table 50206 "Lost Opportunity"
{
    // version TOP010,030B,230,SQLPerform

    // TOP010 KT ABCSI Stock Status Quick Quote Screen 12222014
    //   - Created the table for Lost Opportunity
    // 
    // TOP030B KT ABCSI Lost Opportunities 03112015
    //   - Change the option string for the Document Type field
    // 
    // 2015-09-30 TPZ1049 TAKHMETO
    //   Length of the User ID field has been increased
    // 
    // 2018-12-27
    //   Added key “Sell-to Customer No.”,Type,”No.”


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'Quote,Order,Stock Status';
            OptionMembers = Quote,"Order","Stock Status";
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
        }
        field(3; "Document No."; Code[20])
        {
        }
        field(4; "Line No."; Integer)
        {
        }
        field(5; Type; Option)
        {
            OptionCaption = 'Item';
            OptionMembers = Item;
        }
        field(6; "No."; Code[20])
        {
        }
        field(7; "Location Code"; Code[10])
        {
        }
        field(10; "Shipment Date"; Date)
        {
        }
        field(15; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(60; "Qty. Shipped"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
        }
        field(5415; "Quantity(Base)"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(5460; "Qty. Shipped(Base)"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50011; "Actual Unit Price"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(50020; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(50021; "User ID"; Code[50])
        {
        }
        field(50027; "Reason Code"; Code[10])
        {
        }
        field(50028; "Reason Code Comment"; Text[60])
        {
        }
        field(50077; "Lost Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
        }
        key(Key2; Type, "No.", "Sell-to Customer No.", "Reason Code", "Shipment Date")
        {
        }
        key(Key3; "Sell-to Customer No.", Type, "No.", "Reason Code", "Shipment Date")
        {
        }
        key(Key4; "Reason Code", Type, "No.", "Shipment Date", "Sell-to Customer No.")
        {
        }
        key(Key5; "Sell-to Customer No.", Type, "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

