unit u2023_02_15_19_21_Payment.Seeder;

interface

uses
  uBase.Migration,
  uConnMigration,
  uEnv.Rest,
  uZLConnection.Types;

type
  TSeeder = class(TBaseMigration)
    class function &Register: TSeeder;
  end;

implementation

{ TSeeder }
class function TSeeder.&Register: TSeeder;
const
  LMYSQL_SCRIPT =
    // Payment
    ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (1,''Dinheiro'',1,1,0,1); '+
    ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (2,''Cartão de Débito'',1,1,0,1); '+
    ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (3,''Cartão de Crédito'',1,1,0,1); '+
    ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (4,''Cheque'',1,1,0,1); '+
    ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (5,''Prazo'',0,1,0,1); '+
    ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (6,''Boleto'',0,1,0,1); '+
    ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (7,''Ticket Troca'',1,1,0,1); '+

    // PaymentTerm
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''A VISTA'',1,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''02X'',2,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''03X'',3,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''04X'',4,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''05X'',5,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''06X'',6,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''07X'',7,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''08X'',8,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''09X'',9,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''10X'',10,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''11X'',11,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''12X'',12,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (2,''A VISTA'',1,0,0); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (1,''A VISTA'',1,0,0); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (4,''A VISTA'',1,0,0); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (4,''30 DIAS'',1,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''30 DIAS'',1,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''02X'',2,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''03X'',3,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''04X'',4,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''05X'',5,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''06X'',6,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''07X'',7,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''08X'',8,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''09X'',9,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''10X'',10,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''11X'',11,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''12X'',12,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''05 DIAS'',1,5,5); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''10 DIAS'',1,10,10); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''15 DIAS'',1,15,15); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''20 DIAS'',1,20,20); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''25 DIAS'',1,25,25); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''30 DIAS'',1,30,30); '+
    ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (7,''A VISTA'',1,0,0); ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddSeeder(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TSeeder.&Register;

end.
