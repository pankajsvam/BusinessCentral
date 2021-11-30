tableextension 50110 warehouseRequest extends "Warehouse Request"
{
    fields
    {
        Field(50000; "Sell-to/Transfer-to No."; Code[20]) { }
        Field(50001; "Sell-to/Transfer-to Name"; Text[50]) { }
        Field(50002; "Ship-to Name"; Text[50]) { }
        Field(50003; "Consolidate Orders"; Boolean) { }
        Field(50004; "Activity Status"; Option)
        {
            OptionMembers = " ","Pick Created","Pick Registered",Packing,Packed,Shipped;
        }
        Field(50005; "No. of Picks"; Integer) { }
        Field(50006; "Back Order"; Boolean) { }
        Field(50007; "Division Code"; Code[10]) { }
        Field(50008; "Order Changed"; Boolean) { }
        Field(50009; "Total Order Changed"; Integer) { }
        Field(50010; "Location Filter"; Code[10]) { }
        Field(50011; "Requested Delivery Date"; Date) { }
        Field(50012; "Special Equipment Code"; Code[10]) { }
        Field(50013; "Internal Comment"; Text[30]) { }
        Field(50014; "Pick Type"; Option)
        {
            OptionMembers = " ",TO,SO;
        }
        Field(50015; "Shipping Method"; Code[10]) { }
        Field(50016; "Number of Lines"; Integer) { }
        Field(50017; "Order Date"; Date) { }
        Field(50018; "Delivery Date"; Date) { }
        Field(50020; "Consolidated Order"; Boolean) { }
        Field(72801; "Warehouse Shipment No."; Code[20]) { }
        Field(72802; "Whse. Completely Handled"; Boolean) { }
        Field(72803; "Lines Shipped"; Boolean) { }
        Field(72804; "Warehouse Shipment  Exists"; Boolean) { }
        Field(72805; "Pick Exists"; Boolean) { }
        Field(72806; "Wave Pick Bin Code"; Code[20]) { }
        Field(72807; "Ready to Register"; Boolean) { }
        Field(72808; "Processing Error"; Boolean) { }
        Field(72809; "Wave Pick Whse. Request Exists"; Boolean) { }
        Field(72810; "Wave Pick No."; Code[20]) { }
        Field(72812; "Picking Priority"; Integer) { }
        Field(72815; "Whse. Activity Group No."; Code[20]) { }
        Field(72816; "Action Created By Filter"; Code[50]) { }
        Field(72817; "Action Code"; Code[20]) { }
        Field(72818; "Action Responsible"; Code[50]) { }
        Field(72822; "E-Ship Agent Service"; Code[30]) { }
        Field(72823; "Ship-to Code"; Code[10]) { }
        Field(72824; "Ship-to Country Code"; Code[10]) { }
        Field(72826; "EDI Order"; Boolean) { }
        Field(72827; "Ship-for Code"; Code[20]) { }
        Field(72828; "Total Available Qty."; Decimal) { }
        Field(14099001; "Pick Movement"; Code[20]) { }
        Field(14099002; "Pick Movement Processed"; Boolean) { }
        Field(14099003; "Pallet Pick"; Boolean) { }
        Field(14099004; "First Assembly Order No."; Code[20]) { }
        Field(14099005; "Assembly Pick No."; Code[20]) { }
        Field(14099006; "ATO Pick Required"; Boolean) { }
        Field(14099020; "Pick Request Exists"; Boolean) { }
        Field(14099021; "Pick Request No."; Code[20]) { }
        Field(14099022; "ATO Pick Rqst. Exists"; Boolean) { }
        Field(14099023; "ATO Pick Rqst. No."; Code[20]) { }

    }
}
