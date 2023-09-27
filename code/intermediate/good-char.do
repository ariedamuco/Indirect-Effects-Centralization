
*drop useless chars
drop char1_price_norm char1_norm_factor  char2_drawers_price char11_pri* char11_unit_costri char11_call_durationmrm

foreach var of varlist char1_hd_category char1_maintenance_cat char2_drawers char2_cover char2_frame char2_firehazard_class char3_armrest char3_backrest char3_firehazard_class char5_type char8_payment_mode char8_payment_due char9_type char9_format char9_payment_due char9_delivery char5_resolution char12_software_cat char12_contract_cat char13_printer_type{
	tab `var', gen (`var') 
	
	}

local good1_char "char1_hd_category* char1_screen14plus char1_cd_dvd char1_cd_writer char1_floppy char1_software char1_maintenance char1_maintenance_cat* char1_dvd_writer char1_wifi char1_ramD"

local good2_char "char2_drawers* char2_cover* char2_frame* char2_safety_certificate char2_firehazard_class* char2_delivery_and_setup char2_servproget Lchar2_width Lchar2_depth Lchar2_warranty_months"

local good3_char "char3_armrest* char3_backrest* char3_safety_certificate char3_firehazard_class* char3_warranty_months char3_delivery_and_setup"

local good4_char "char4_national_calls char4_mobile_calls char4_local_calls char4_ip_calls char4_international_calls1 char4_ghost char4_connection_charge" 
local good5_char "char5_type* char5_brightness char5_contrast char5_resolution1 char5_maintenance char5_maintenance_duration char5_maintenance_location"
local good6_char "char6_inspection char6_design char6_installation char6_configuration char6_trial char6_maintenance char6_maintenance_duration char6_maintenance_parts"
local good7_char "char7_inspection char7_design char7_installation char7_labelling char7_trial char7_certification char7_system_management char7_maintenance char7_maintenance_duration Lchar7_fibers_total"
local good8_char "char8_payment_mode* char8_payment_due* char8_evoucher Lchar8_contract_length"
local good9_char "char9_type* char9_format3 char9_color char9_delivery* Lchar9_contract_length char9_delay_delivery char9_payment_due* char9_forest_sustainable char9_ecf char9_weight"
local good10_char "char10_autocharge char10_maintenance Lchar10_speed Lchar10_modem_speed"
local good11_char "char11_order_no char11_provider char11_quantity_sim char11_quantity_rentalphones char11_quantity_sms char11_call_durationml char11_total_costml char11_unit_costml char11_call_durationmm"
local good12_char "char12_software_cat* char12_contract_cat*"
local good13_char "char13_printer_type* char13_color char13_twosided char13_netlink char13_finisher char13_drawer char13_materials Lchar13_speed Lchar13_maintenance"
local goods_char "`good1_char' `good2_char' `good3_char' `good4_char' `good5_char' `good6_char' `good7_char' `good8_char' `good9_char' `good10_char' `good11_char' `good12_char' `good13_char'"
*local goods_char1 "`good1_char' `good2_char' `good3_char' `good4_char' `good5_char' `good6_char' `good7_char' `good8_char' `good9_char' `good10_char' `good11_char' `good12_char' `good13_char' i.brand"
global quantity "quantity1 quantity2 quantity3 quantity4 quantity5 quantity6 quantity7 quantity8 quantity9 quantity10 quantity11 quantity12 quantity13 "


global lasso_char "char1_hd_category3 char1_ramD char2_safety_certificate Lchar2_width Lchar2_depth char6_installation Lchar7_fibers_total char8_payment_due5 char9_type char9_type3 char9_format3 char9_delivery4 Lchar9_contract_length char9_payment_due4 Lchar10_modem_speed char11_provider char12_contract_cat2 char13_printer_type2 char13_twosided char13_netlink char13_drawer"


local lasso_char $lasso_char
