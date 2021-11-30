pageextension 50202 "TPZItemCard" extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; rec."Description 2")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Description 2"; "Base Unit of Measure")
        addafter("Base Unit of Measure")
        {
            field("Alt. Base Unit of Measure"; rec."Alt. Base Unit of Measure")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Alt. Base Unit of Measure"; AssemblyBOM, Type, "Automatic Ext. Texts", "Created From Nonstock Item", "Item Category Code")
        addafter("Item Category Code")
        {
            field("Manufacturer Code"; rec."Manufacturer Code")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Manufacturer Code"; "Search Description")
        addafter("Search Description")
        {
            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 5 Code"; rec."Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
            }
        }
        /*
        field(ProductLifeCycleCode;Page30EventSubscriber.Pg30_OnAfterGetRecord_1(Rec))
        {
            ApplicationArea = All;
        }
        */
        moveafter("Shortcut Dimension 5 Code"; Inventory, "Qty. on Purch. Order", "Qty. on Prod. Order", "Qty. on Component Lines", "Qty. on Sales Order", "Qty. on Service Order", "Qty. on Job Order", "Qty. on Assembly Order", "Qty. on Asm. Component")
        addafter("Qty. on Asm. Component")
        {
            field("Qty. Available"; rec.Inventory - rec."Qty. on Sales Order")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Qty. Available"; Blocked)
        addafter(Blocked)
        {
            field("Blocked Reason Code"; rec."Blocked Reason Code")
            {
                ApplicationArea = All;
            }
            field("Blocked Sequence"; rec."Blocked Sequence")
            {
                ApplicationArea = All;
            }
            field("Alternative Item No."; rec."Alternative Item No.")
            {
                ApplicationArea = All;
            }
            field("Prior Generation"; rec."Prior Generation")
            {
                ApplicationArea = All;
            }
            field("Next Generation"; rec."Next Generation")
            {
                ApplicationArea = All;
            }
            field("Date Created"; rec."Date Created")
            {
                ApplicationArea = All;
            }
            field("Created by User ID"; rec."Created by User ID")
            {
                ApplicationArea = All;
            }
            field("Sales Order Multiple"; rec."Sales Order Multiple")
            {
                ApplicationArea = All;
            }
            field("Sorting Order"; rec."Sorting Order")
            {
                ApplicationArea = All;
            }
            field("SupplyHouse.com"; rec."SupplyHouse.com")
            {
                ApplicationArea = All;
            }
        }
    }
}




