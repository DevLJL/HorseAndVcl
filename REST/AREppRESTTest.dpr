{$DEFINE DUNITX}
{$DEFINE APPREST}
program AREppRESTTest;

{$IFNDEF TESTINSIGHT}
  {$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  uTestLoad.View in 'Config\uTestLoad.View.pas' {TestLoadView},
  {$ENDIF }
  uEnv.Rest in 'Config\uEnv.Rest.pas',
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Vcl.Forms,
  Winapi.Windows,
  DataSet.Serialize,
  System.IOUtils,
  uConnection.Factory in 'Config\uConnection.Factory.pas',
  uConnMigration in 'Config\uConnMigration.pas',
  uBase.Repository.Interfaces in 'Shared\Repository\uBase.Repository.Interfaces.pas',
  uBase.Repository in 'Shared\Repository\uBase.Repository.pas',
  uRepository.Factory in 'Shared\Repository\uRepository.Factory.pas',
  uBase.Entity in 'Shared\Entity\uBase.Entity.pas',
  uFilter in 'Shared\Entity\uFilter.pas',
  uFilter.Types in 'Shared\Entity\uFilter.Types.pas',
  uIndexResult in 'Shared\Entity\uIndexResult.pas',
  uSelectWithFilter in 'Shared\Entity\uSelectWithFilter.pas',
  uValidation.Interfaces in 'Shared\Entity\uValidation.Interfaces.pas',
  uHlp in 'Shared\Util\uHlp.pas',
  uMemTable.Factory in 'Config\uMemTable.Factory.pas',
  uAppRest.Types in 'Config\uAppRest.Types.pas',
  uTrans in 'Shared\Resources\uTrans.pas',
  uEntityValidation.Exception in 'Shared\Exception\uEntityValidation.Exception.pas',
  uApplication.Exception in 'Config\uApplication.Exception.pas',
  uBase.DTO in 'Shared\DTO\uBase.DTO.pas',
  uBase.Filter.DTO in 'Shared\DTO\uBase.Filter.DTO.pas',
  uMyClaims in 'Config\uMyClaims.pas',
  uResponse.DTO in 'Shared\DTO\uResponse.DTO.pas',
  uMapper.Interfaces in 'Shared\Mapper\uMapper.Interfaces.pas',
  uBase.SQLBuilder.Interfaces in 'Shared\SQLBuilder\uBase.SQLBuilder.Interfaces.pas',
  uSQLBuilder.Factory in 'Shared\SQLBuilder\uSQLBuilder.Factory.pas',
  uBase.DataFactory in 'Shared\DataFactory\uBase.DataFactory.pas',
  uBase.Migration in 'Config\uBase.Migration.pas',
  u2023_02_08_09_20_CreateAclRoleTable.Migration in 'Config\Migrations\u2023_02_08_09_20_CreateAclRoleTable.Migration.pas',
  u2023_02_08_09_55_CreateAclUserTable.Migration in 'Config\Migrations\u2023_02_08_09_55_CreateAclUserTable.Migration.pas',
  u2023_02_10_11_14_CreateBrandTable.Migration in 'Config\Migrations\u2023_02_10_11_14_CreateBrandTable.Migration.pas',
  u2023_02_08_09_21_AclRole.seeder in 'Config\Seeders\u2023_02_08_09_21_AclRole.seeder.pas',
  u2023_02_08_09_56_AclUser.seeder in 'Config\Seeders\u2023_02_08_09_56_AclUser.seeder.pas',
  uAclRole.Mapper in 'Module\Auth\AclRole\Mapper\uAclRole.Mapper.pas',
  uAclRole.Show.DTO in 'Module\Auth\AclRole\DTO\uAclRole.Show.DTO.pas',
  uAclRole.Input.DTO in 'Module\Auth\AclRole\DTO\uAclRole.Input.DTO.pas',
  uAclRole.Filter in 'Module\Auth\AclRole\Filter\uAclRole.Filter.pas',
  uAclRole.Filter.DTO in 'Module\Auth\AclRole\Filter\uAclRole.Filter.DTO.pas',
  uAclRole.Persistence.UseCase in 'Module\Auth\AclRole\UseCase\uAclRole.Persistence.UseCase.pas',
  uAclRole.SQLBuilder.MySQL in 'Module\Auth\AclRole\SQLBuilder\uAclRole.SQLBuilder.MySQL.pas',
  uAclRole.SQLBuilder.Interfaces in 'Module\Auth\AclRole\SQLBuilder\uAclRole.SQLBuilder.Interfaces.pas',
  uAclRole.Repository.Interfaces in 'Module\Auth\AclRole\Repository\uAclRole.Repository.Interfaces.pas',
  uAclRole.Repository.SQL in 'Module\Auth\AclRole\Repository\uAclRole.Repository.SQL.pas',
  uAclRole in 'Module\Auth\AclRole\Domain\Entity\uAclRole.pas',
  uAclUser.Mapper in 'Module\Auth\AclUser\Mapper\uAclUser.Mapper.pas',
  uAclUser.Show.DTO in 'Module\Auth\AclUser\DTO\uAclUser.Show.DTO.pas',
  uAclUser.SQLBuilder.MySQL in 'Module\Auth\AclUser\SQLBuilder\uAclUser.SQLBuilder.MySQL.pas',
  uAclUser.Auth.UseCase in 'Module\Auth\AclUser\UseCase\uAclUser.Auth.UseCase.pas',
  uAclUser.Input.DTO in 'Module\Auth\AclUser\DTO\uAclUser.Input.DTO.pas',
  uAclUser in 'Module\Auth\AclUser\Domain\Entity\uAclUser.pas',
  uAclUser.Login.DTO in 'Module\Auth\AclUser\DTO\uAclUser.Login.DTO.pas',
  uAclUser.Filter in 'Module\Auth\AclUser\Filter\uAclUser.Filter.pas',
  uAclUser.Filter.DTO in 'Module\Auth\AclUser\DTO\uAclUser.Filter.DTO.pas',
  uAclUser.Persistence.UseCase in 'Module\Auth\AclUser\UseCase\uAclUser.Persistence.UseCase.pas',
  uAclUser.Login.UseCase in 'Module\Auth\AclUser\UseCase\uAclUser.Login.UseCase.pas',
  uAclUser.SQLBuilder.Interfaces in 'Module\Auth\AclUser\SQLBuilder\uAclUser.SQLBuilder.Interfaces.pas',
  uAclUser.Repository.Interfaces in 'Module\Auth\AclUser\Repository\uAclUser.Repository.Interfaces.pas',
  uAclUser.Repository.SQL in 'Module\Auth\AclUser\Repository\uAclUser.Repository.SQL.pas',
  uBrand.Test in 'Module\Stock\Brand\Test\uBrand.Test.pas',
  uBrand.Mapper in 'Module\Stock\Brand\Mapper\uBrand.Mapper.pas',
  uBrand in 'Module\Stock\Brand\Domain\Entity\uBrand.pas',
  uBrand.Repository.SQL in 'Module\Stock\Brand\Repository\uBrand.Repository.SQL.pas',
  uBrand.Input.DTO in 'Module\Stock\Brand\DTO\uBrand.Input.DTO.pas',
  uBrand.Show.DTO in 'Module\Stock\Brand\DTO\uBrand.Show.DTO.pas',
  uBrand.SQLBuilder.MySQL in 'Module\Stock\Brand\SQLBuilder\uBrand.SQLBuilder.MySQL.pas',
  uBrand.Filter in 'Module\Stock\Brand\Filter\uBrand.Filter.pas',
  uBrand.Filter.DTO in 'Module\Stock\Brand\DTO\uBrand.Filter.DTO.pas',
  uBrand.Persistence.UseCase in 'Module\Stock\Brand\UseCase\uBrand.Persistence.UseCase.pas',
  uBrand.SQLBuilder.Interfaces in 'Module\Stock\Brand\SQLBuilder\uBrand.SQLBuilder.Interfaces.pas',
  uBrand.Repository.Interfaces in 'Module\Stock\Brand\Repository\uBrand.Repository.Interfaces.pas',
  uBrand.DataFactory in 'Module\Stock\Brand\DataFactory\uBrand.DataFactory.pas',
  uCategory.Mapper in 'Module\Stock\Category\Mapper\uCategory.Mapper.pas',
  uCategory.SQLBuilder.MySQL in 'Module\Stock\Category\SQLBuilder\uCategory.SQLBuilder.MySQL.pas',
  uCategory.Persistence.UseCase in 'Module\Stock\Category\UseCase\uCategory.Persistence.UseCase.pas',
  uCategory.Test in 'Module\Stock\Category\Test\uCategory.Test.pas',
  uCategory.Repository.Interfaces in 'Module\Stock\Category\Repository\uCategory.Repository.Interfaces.pas',
  uCategory.Repository.SQL in 'Module\Stock\Category\Repository\uCategory.Repository.SQL.pas',
  uCategory.SQLBuilder.Interfaces in 'Module\Stock\Category\SQLBuilder\uCategory.SQLBuilder.Interfaces.pas',
  uCategory.Filter in 'Module\Stock\Category\Filter\uCategory.Filter.pas',
  uCategory in 'Module\Stock\Category\Domain\Entity\uCategory.pas',
  uCategory.Input.DTO in 'Module\Stock\Category\DTO\uCategory.Input.DTO.pas',
  uCategory.Show.DTO in 'Module\Stock\Category\DTO\uCategory.Show.DTO.pas',
  uCategory.DataFactory in 'Module\Stock\Category\DataFactory\uCategory.DataFactory.pas',
  uCategory.Filter.DTO in 'Module\Stock\Category\DTO\uCategory.Filter.DTO.pas',
  u2023_02_07_10_00_CreateStationTable.Migration in 'Config\Migrations\u2023_02_07_10_00_CreateStationTable.Migration.pas',
  uStation.SQLBuilder.MySQL in 'Module\General\Station\SQLBuilder\uStation.SQLBuilder.MySQL.pas',
  uStation.DataFactory in 'Module\General\Station\DataFactory\uStation.DataFactory.pas',
  uStation.Input.DTO in 'Module\General\Station\DTO\uStation.Input.DTO.pas',
  uStation.Mapper in 'Module\General\Station\Mapper\uStation.Mapper.pas',
  uStation in 'Module\General\Station\Domain\Entity\uStation.pas',
  uStation.Test in 'Module\General\Station\Test\uStation.Test.pas',
  uStation.Repository.SQL in 'Module\General\Station\Repository\uStation.Repository.SQL.pas',
  uStation.Show.DTO in 'Module\General\Station\DTO\uStation.Show.DTO.pas',
  uStation.Persistence.UseCase in 'Module\General\Station\UseCase\uStation.Persistence.UseCase.pas',
  uStation.SQLBuilder.Interfaces in 'Module\General\Station\SQLBuilder\uStation.SQLBuilder.Interfaces.pas',
  uStation.Filter in 'Module\General\Station\Filter\uStation.Filter.pas',
  uStation.Repository.Interfaces in 'Module\General\Station\Repository\uStation.Repository.Interfaces.pas',
  uStation.Filter.DTO in 'Module\General\Station\DTO\uStation.Filter.DTO.pas',
  u2023_02_11_23_13_CreateCityTable.Migration in 'Config\Migrations\u2023_02_11_23_13_CreateCityTable.Migration.pas',
  u2023_02_07_10_01_Station.seeder in 'Config\Seeders\u2023_02_07_10_01_Station.seeder.pas',
  u2023_02_11_23_14_City.seeder in 'Config\Seeders\u2023_02_11_23_14_City.seeder.pas',
  uCity.SQLBuilder.MySQL in 'Module\General\City\SQLBuilder\uCity.SQLBuilder.MySQL.pas',
  uCity.Mapper in 'Module\General\City\Mapper\uCity.Mapper.pas',
  uCity.Persistence.UseCase in 'Module\General\City\UseCase\uCity.Persistence.UseCase.pas',
  uCity.Test in 'Module\General\City\Test\uCity.Test.pas',
  uCity.Repository.Interfaces in 'Module\General\City\Repository\uCity.Repository.Interfaces.pas',
  uCity.Repository.SQL in 'Module\General\City\Repository\uCity.Repository.SQL.pas',
  uCity.SQLBuilder.Interfaces in 'Module\General\City\SQLBuilder\uCity.SQLBuilder.Interfaces.pas',
  uCity.Filter in 'Module\General\City\Filter\uCity.Filter.pas',
  uCity in 'Module\General\City\Domain\Entity\uCity.pas',
  uCity.Filter.DTO in 'Module\General\City\DTO\uCity.Filter.DTO.pas',
  uCity.Input.DTO in 'Module\General\City\DTO\uCity.Input.DTO.pas',
  uCity.Show.DTO in 'Module\General\City\DTO\uCity.Show.DTO.pas',
  uCity.DataFactory in 'Module\General\City\DataFactory\uCity.DataFactory.pas',
  u2023_02_11_23_35_CreateCompanyTable.Migration in 'Config\Migrations\u2023_02_11_23_35_CreateCompanyTable.Migration.pas',
  uCompany.SQLBuilder.MySQL in 'Module\General\Company\SQLBuilder\uCompany.SQLBuilder.MySQL.pas',
  uCompany.Mapper in 'Module\General\Company\Mapper\uCompany.Mapper.pas',
  uCompany.Persistence.UseCase in 'Module\General\Company\UseCase\uCompany.Persistence.UseCase.pas',
  uCompany.Test in 'Module\General\Company\Test\uCompany.Test.pas',
  uCompany.Repository.Interfaces in 'Module\General\Company\Repository\uCompany.Repository.Interfaces.pas',
  uCompany.SQLBuilder.Interfaces in 'Module\General\Company\SQLBuilder\uCompany.SQLBuilder.Interfaces.pas',
  uCompany.Repository.SQL in 'Module\General\Company\Repository\uCompany.Repository.SQL.pas',
  uCompany.Filter in 'Module\General\Company\Filter\uCompany.Filter.pas',
  uCompany in 'Module\General\Company\Domain\Entity\uCompany.pas',
  uCompany.Input.DTO in 'Module\General\Company\DTO\uCompany.Input.DTO.pas',
  uCompany.Show.DTO in 'Module\General\Company\DTO\uCompany.Show.DTO.pas',
  uCompany.DataFactory in 'Module\General\Company\DataFactory\uCompany.DataFactory.pas',
  uCompany.Filter.DTO in 'Module\General\Company\DTO\uCompany.Filter.DTO.pas',
  uCompany.BeforeSave in 'Module\General\Company\Domain\DomainService\uCompany.BeforeSave.pas',
  u2023_02_12_00_00_CreatePersonTable.Migration in 'Config\Migrations\u2023_02_12_00_00_CreatePersonTable.Migration.pas',
  u2023_02_12_00_01_CreatePersonContactTable.Migration in 'Config\Migrations\u2023_02_12_00_01_CreatePersonContactTable.Migration.pas',
  uPerson.Mapper in 'Module\General\Person\Mapper\uPerson.Mapper.pas',
  uPerson.SQLBuilder.MySQL in 'Module\General\Person\SQLBuilder\uPerson.SQLBuilder.MySQL.pas',
  uPerson.Persistence.UseCase in 'Module\General\Person\UseCase\uPerson.Persistence.UseCase.pas',
  uPerson.Test in 'Module\General\Person\Test\uPerson.Test.pas',
  uPerson.SQLBuilder.Interfaces in 'Module\General\Person\SQLBuilder\uPerson.SQLBuilder.Interfaces.pas',
  uPerson.Repository.Interfaces in 'Module\General\Person\Repository\uPerson.Repository.Interfaces.pas',
  uPerson.Repository.SQL in 'Module\General\Person\Repository\uPerson.Repository.SQL.pas',
  uPerson.Filter in 'Module\General\Person\Filter\uPerson.Filter.pas',
  uPerson in 'Module\General\Person\Domain\Entity\uPerson.pas',
  uPerson.Show.DTO in 'Module\General\Person\DTO\uPerson.Show.DTO.pas',
  uPerson.Input.DTO in 'Module\General\Person\DTO\uPerson.Input.DTO.pas',
  uPerson.DataFactory in 'Module\General\Person\DataFactory\uPerson.DataFactory.pas',
  uPerson.Filter.DTO in 'Module\General\Person\DTO\uPerson.Filter.DTO.pas',
  uPersonContact.Input.DTO in 'Module\General\Person\DTO\uPersonContact.Input.DTO.pas',
  uPersonContact in 'Module\General\Person\Domain\Entity\uPersonContact.pas',
  uPerson.Types in 'Module\General\Person\Domain\Types\uPerson.Types.pas',
  uPerson.BeforeSave in 'Module\General\Person\Domain\DomainService\uPerson.BeforeSave.pas',
  u2023_02_13_12_32_CreateUnitTable.Migration in 'Config\Migrations\u2023_02_13_12_32_CreateUnitTable.Migration.pas',
  uUnit.SQLBuilder.MySQL in 'Module\Stock\Unit\SQLBuilder\uUnit.SQLBuilder.MySQL.pas',
  uUnit.Mapper in 'Module\Stock\Unit\Mapper\uUnit.Mapper.pas',
  uUnit.Persistence.UseCase in 'Module\Stock\Unit\UseCase\uUnit.Persistence.UseCase.pas',
  uUnit.Test in 'Module\Stock\Unit\Test\uUnit.Test.pas',
  uUnit.SQLBuilder.Interfaces in 'Module\Stock\Unit\SQLBuilder\uUnit.SQLBuilder.Interfaces.pas',
  uUnit.Repository.SQL in 'Module\Stock\Unit\Repository\uUnit.Repository.SQL.pas',
  uUnit.Repository.Interfaces in 'Module\Stock\Unit\Repository\uUnit.Repository.Interfaces.pas',
  uUnit.Filter in 'Module\Stock\Unit\Filter\uUnit.Filter.pas',
  uUnit in 'Module\Stock\Unit\Domain\Entity\uUnit.pas',
  uUnit.Show.DTO in 'Module\Stock\Unit\DTO\uUnit.Show.DTO.pas',
  uUnit.Filter.DTO in 'Module\Stock\Unit\DTO\uUnit.Filter.DTO.pas',
  uUnit.Input.DTO in 'Module\Stock\Unit\DTO\uUnit.Input.DTO.pas',
  uUnit.DataFactory in 'Module\Stock\Unit\DataFactory\uUnit.DataFactory.pas',
  u2023_02_13_13_46_CreateNcmTable.Migration in 'Config\Migrations\u2023_02_13_13_46_CreateNcmTable.Migration.pas',
  uNcm.Mapper in 'Module\Stock\Ncm\Mapper\uNcm.Mapper.pas',
  uNcm.SQLBuilder.MySQL in 'Module\Stock\Ncm\SQLBuilder\uNcm.SQLBuilder.MySQL.pas',
  uNcm.Persistence.UseCase in 'Module\Stock\Ncm\UseCase\uNcm.Persistence.UseCase.pas',
  uNcm.Test in 'Module\Stock\Ncm\Test\uNcm.Test.pas',
  uNcm.SQLBuilder.Interfaces in 'Module\Stock\Ncm\SQLBuilder\uNcm.SQLBuilder.Interfaces.pas',
  uNcm.Repository.Interfaces in 'Module\Stock\Ncm\Repository\uNcm.Repository.Interfaces.pas',
  uNcm.Repository.SQL in 'Module\Stock\Ncm\Repository\uNcm.Repository.SQL.pas',
  uNcm.Filter in 'Module\Stock\Ncm\Filter\uNcm.Filter.pas',
  uNcm in 'Module\Stock\Ncm\Domain\Entity\uNcm.pas',
  uNcm.Show.DTO in 'Module\Stock\Ncm\DTO\uNcm.Show.DTO.pas',
  uNcm.Filter.DTO in 'Module\Stock\Ncm\DTO\uNcm.Filter.DTO.pas',
  uNcm.Input.DTO in 'Module\Stock\Ncm\DTO\uNcm.Input.DTO.pas',
  uNcm.DataFactory in 'Module\Stock\Ncm\DataFactory\uNcm.DataFactory.pas',
  u2023_02_13_17_56_CreateCategoryTable.Migration in 'Config\Migrations\u2023_02_13_17_56_CreateCategoryTable.Migration.pas',
  u2023_02_13_18_00_CreateSizeTable.Migration in 'Config\Migrations\u2023_02_13_18_00_CreateSizeTable.Migration.pas',
  uSize.SQLBuilder.MySQL in 'Module\Stock\Size\SQLBuilder\uSize.SQLBuilder.MySQL.pas',
  uSize.Mapper in 'Module\Stock\Size\Mapper\uSize.Mapper.pas',
  uSize.Persistence.UseCase in 'Module\Stock\Size\UseCase\uSize.Persistence.UseCase.pas',
  uSize.Test in 'Module\Stock\Size\Test\uSize.Test.pas',
  uSize.Repository.SQL in 'Module\Stock\Size\Repository\uSize.Repository.SQL.pas',
  uSize.SQLBuilder.Interfaces in 'Module\Stock\Size\SQLBuilder\uSize.SQLBuilder.Interfaces.pas',
  uSize.Repository.Interfaces in 'Module\Stock\Size\Repository\uSize.Repository.Interfaces.pas',
  uSize.Filter in 'Module\Stock\Size\Filter\uSize.Filter.pas',
  uSize in 'Module\Stock\Size\Domain\Entity\uSize.pas',
  uSize.Filter.DTO in 'Module\Stock\Size\DTO\uSize.Filter.DTO.pas',
  uSize.Input.DTO in 'Module\Stock\Size\DTO\uSize.Input.DTO.pas',
  uSize.Show.DTO in 'Module\Stock\Size\DTO\uSize.Show.DTO.pas',
  uSize.DataFactory in 'Module\Stock\Size\DataFactory\uSize.DataFactory.pas',
  u2023_02_13_18_19_CreateStorageLocationTable.Migration in 'Config\Migrations\u2023_02_13_18_19_CreateStorageLocationTable.Migration.pas',
  uStorageLocation.SQLBuilder.MySQL in 'Module\Stock\StorageLocation\SQLBuilder\uStorageLocation.SQLBuilder.MySQL.pas',
  uStorageLocation.Mapper in 'Module\Stock\StorageLocation\Mapper\uStorageLocation.Mapper.pas',
  uStorageLocation.Persistence.UseCase in 'Module\Stock\StorageLocation\UseCase\uStorageLocation.Persistence.UseCase.pas',
  uStorageLocation.Test in 'Module\Stock\StorageLocation\Test\uStorageLocation.Test.pas',
  uStorageLocation.Repository.SQL in 'Module\Stock\StorageLocation\Repository\uStorageLocation.Repository.SQL.pas',
  uStorageLocation.SQLBuilder.Interfaces in 'Module\Stock\StorageLocation\SQLBuilder\uStorageLocation.SQLBuilder.Interfaces.pas',
  uStorageLocation.Filter in 'Module\Stock\StorageLocation\Filter\uStorageLocation.Filter.pas',
  uStorageLocation.Repository.Interfaces in 'Module\Stock\StorageLocation\Repository\uStorageLocation.Repository.Interfaces.pas',
  uStorageLocation.Filter.DTO in 'Module\Stock\StorageLocation\DTO\uStorageLocation.Filter.DTO.pas',
  uStorageLocation.Input.DTO in 'Module\Stock\StorageLocation\DTO\uStorageLocation.Input.DTO.pas',
  uStorageLocation in 'Module\Stock\StorageLocation\Domain\Entity\uStorageLocation.pas',
  uStorageLocation.Show.DTO in 'Module\Stock\StorageLocation\DTO\uStorageLocation.Show.DTO.pas',
  uStorageLocation.DataFactory in 'Module\Stock\StorageLocation\DataFactory\uStorageLocation.DataFactory.pas',
  u2023_02_13_18_26_CreateProductTable.Migration in 'Config\Migrations\u2023_02_13_18_26_CreateProductTable.Migration.pas',
  uProduct.DataFactory in 'Module\Stock\Product\DataFactory\uProduct.DataFactory.pas',
  uProduct.Test in 'Module\Stock\Product\Test\uProduct.Test.pas',
  uProduct.Persistence.UseCase in 'Module\Stock\Product\UseCase\uProduct.Persistence.UseCase.pas',
  uProduct.Mapper in 'Module\Stock\Product\Mapper\uProduct.Mapper.pas',
  uProduct in 'Module\Stock\Product\Domain\Entity\uProduct.pas',
  uProduct.Repository.SQL in 'Module\Stock\Product\Repository\uProduct.Repository.SQL.pas',
  uProduct.Input.DTO in 'Module\Stock\Product\DTO\uProduct.Input.DTO.pas',
  uProduct.Show.DTO in 'Module\Stock\Product\DTO\uProduct.Show.DTO.pas',
  uProduct.SQLBuilder.MySQL in 'Module\Stock\Product\SQLBuilder\uProduct.SQLBuilder.MySQL.pas',
  uProduct.Filter in 'Module\Stock\Product\Filter\uProduct.Filter.pas',
  uProduct.Filter.DTO in 'Module\Stock\Product\DTO\uProduct.Filter.DTO.pas',
  uProduct.SQLBuilder.Interfaces in 'Module\Stock\Product\SQLBuilder\uProduct.SQLBuilder.Interfaces.pas',
  uProduct.Repository.Interfaces in 'Module\Stock\Product\Repository\uProduct.Repository.Interfaces.pas',
  uProduct.Types in 'Module\Stock\Product\Domain\Types\uProduct.Types.pas',
  uProduct.BeforeSave in 'Module\Stock\Product\Domain\DomainService\uProduct.BeforeSave.pas',
  u2023_02_13_21_41_CreateBankTable.Migration in 'Config\Migrations\u2023_02_13_21_41_CreateBankTable.Migration.pas',
  u2023_02_13_12_33_Unit.seeder in 'Config\Seeders\u2023_02_13_12_33_Unit.seeder.pas',
  u2023_02_13_13_47_Ncm.seeder in 'Config\Seeders\u2023_02_13_13_47_Ncm.seeder.pas',
  u2023_02_13_18_01_Size.seeder in 'Config\Seeders\u2023_02_13_18_01_Size.seeder.pas',
  u2023_02_13_21_42_Bank.seeder in 'Config\Seeders\u2023_02_13_21_42_Bank.seeder.pas',
  uBank.Persistence.UseCase in 'Module\Financial\Bank\UseCase\uBank.Persistence.UseCase.pas',
  uBank.Test in 'Module\Financial\Bank\Test\uBank.Test.pas',
  uBank.Repository.SQL in 'Module\Financial\Bank\Repository\uBank.Repository.SQL.pas',
  uBank.SQLBuilder.Interfaces in 'Module\Financial\Bank\SQLBuilder\uBank.SQLBuilder.Interfaces.pas',
  uBank.SQLBuilder.MySQL in 'Module\Financial\Bank\SQLBuilder\uBank.SQLBuilder.MySQL.pas',
  uBank.Filter in 'Module\Financial\Bank\Filter\uBank.Filter.pas',
  uBank.Mapper in 'Module\Financial\Bank\Mapper\uBank.Mapper.pas',
  uBank.Repository.Interfaces in 'Module\Financial\Bank\Repository\uBank.Repository.Interfaces.pas',
  uBank.Filter.DTO in 'Module\Financial\Bank\DTO\uBank.Filter.DTO.pas',
  uBank.Input.DTO in 'Module\Financial\Bank\DTO\uBank.Input.DTO.pas',
  uBank in 'Module\Financial\Bank\Domain\Entity\uBank.pas',
  uBank.Show.DTO in 'Module\Financial\Bank\DTO\uBank.Show.DTO.pas',
  uBank.DataFactory in 'Module\Financial\Bank\DataFactory\uBank.DataFactory.pas',
  u2023_02_13_21_57_CreateCostCenterTable.Migration in 'Config\Migrations\u2023_02_13_21_57_CreateCostCenterTable.Migration.pas',
  u2023_02_13_22_03_CreateBankAccountTable.Migration in 'Config\Migrations\u2023_02_13_22_03_CreateBankAccountTable.Migration.pas',
  uCostCenter.Input.DTO in 'Module\Financial\CostCenter\DTO\uCostCenter.Input.DTO.pas',
  uCostCenter.Test in 'Module\Financial\CostCenter\Test\uCostCenter.Test.pas',
  uCostCenter.SQLBuilder.MySQL in 'Module\Financial\CostCenter\SQLBuilder\uCostCenter.SQLBuilder.MySQL.pas',
  uCostCenter.DataFactory in 'Module\Financial\CostCenter\DataFactory\uCostCenter.DataFactory.pas',
  uCostCenter in 'Module\Financial\CostCenter\Domain\Entity\uCostCenter.pas',
  uCostCenter.Mapper in 'Module\Financial\CostCenter\Mapper\uCostCenter.Mapper.pas',
  uCostCenter.Persistence.UseCase in 'Module\Financial\CostCenter\UseCase\uCostCenter.Persistence.UseCase.pas',
  uCostCenter.Repository.SQL in 'Module\Financial\CostCenter\Repository\uCostCenter.Repository.SQL.pas',
  uCostCenter.SQLBuilder.Interfaces in 'Module\Financial\CostCenter\SQLBuilder\uCostCenter.SQLBuilder.Interfaces.pas',
  uCostCenter.Filter in 'Module\Financial\CostCenter\Filter\uCostCenter.Filter.pas',
  uCostCenter.Repository.Interfaces in 'Module\Financial\CostCenter\Repository\uCostCenter.Repository.Interfaces.pas',
  uCostCenter.Filter.DTO in 'Module\Financial\CostCenter\DTO\uCostCenter.Filter.DTO.pas',
  uCostCenter.Show.DTO in 'Module\Financial\CostCenter\DTO\uCostCenter.Show.DTO.pas',
  uBankAccount.SQLBuilder.MySQL in 'Module\Financial\BankAccount\SQLBuilder\uBankAccount.SQLBuilder.MySQL.pas',
  uBankAccount.Mapper in 'Module\Financial\BankAccount\Mapper\uBankAccount.Mapper.pas',
  uBankAccount.Persistence.UseCase in 'Module\Financial\BankAccount\UseCase\uBankAccount.Persistence.UseCase.pas',
  uBankAccount.Test in 'Module\Financial\BankAccount\Test\uBankAccount.Test.pas',
  uBankAccount.SQLBuilder.Interfaces in 'Module\Financial\BankAccount\SQLBuilder\uBankAccount.SQLBuilder.Interfaces.pas',
  uBankAccount.Repository.Interfaces in 'Module\Financial\BankAccount\Repository\uBankAccount.Repository.Interfaces.pas',
  uBankAccount.Repository.SQL in 'Module\Financial\BankAccount\Repository\uBankAccount.Repository.SQL.pas',
  uBankAccount.Filter in 'Module\Financial\BankAccount\Filter\uBankAccount.Filter.pas',
  uBankAccount in 'Module\Financial\BankAccount\Domain\Entity\uBankAccount.pas',
  uBankAccount.Show.DTO in 'Module\Financial\BankAccount\DTO\uBankAccount.Show.DTO.pas',
  uBankAccount.DataFactory in 'Module\Financial\BankAccount\DataFactory\uBankAccount.DataFactory.pas',
  uBankAccount.Filter.DTO in 'Module\Financial\BankAccount\DTO\uBankAccount.Filter.DTO.pas',
  uBankAccount.Input.DTO in 'Module\Financial\BankAccount\DTO\uBankAccount.Input.DTO.pas',
  u2023_02_13_22_04_BankAccount.seeder in 'Config\Seeders\u2023_02_13_22_04_BankAccount.seeder.pas',
  uChartOfAccount.Persistence.UseCase in 'Module\Financial\ChartOfAccount\UseCase\uChartOfAccount.Persistence.UseCase.pas',
  uChartOfAccount.Test in 'Module\Financial\ChartOfAccount\Test\uChartOfAccount.Test.pas',
  uChartOfAccount.SQLBuilder.Interfaces in 'Module\Financial\ChartOfAccount\SQLBuilder\uChartOfAccount.SQLBuilder.Interfaces.pas',
  uChartOfAccount.SQLBuilder.MySQL in 'Module\Financial\ChartOfAccount\SQLBuilder\uChartOfAccount.SQLBuilder.MySQL.pas',
  uChartOfAccount.Mapper in 'Module\Financial\ChartOfAccount\Mapper\uChartOfAccount.Mapper.pas',
  uChartOfAccount.Repository.Interfaces in 'Module\Financial\ChartOfAccount\Repository\uChartOfAccount.Repository.Interfaces.pas',
  uChartOfAccount.Repository.SQL in 'Module\Financial\ChartOfAccount\Repository\uChartOfAccount.Repository.SQL.pas',
  uChartOfAccount.Filter in 'Module\Financial\ChartOfAccount\Filter\uChartOfAccount.Filter.pas',
  uChartOfAccount.Input.DTO in 'Module\Financial\ChartOfAccount\DTO\uChartOfAccount.Input.DTO.pas',
  uChartOfAccount in 'Module\Financial\ChartOfAccount\Domain\Entity\uChartOfAccount.pas',
  uChartOfAccount.Show.DTO in 'Module\Financial\ChartOfAccount\DTO\uChartOfAccount.Show.DTO.pas',
  uChartOfAccount.DataFactory in 'Module\Financial\ChartOfAccount\DataFactory\uChartOfAccount.DataFactory.pas',
  uChartOfAccount.Filter.DTO in 'Module\Financial\ChartOfAccount\DTO\uChartOfAccount.Filter.DTO.pas',
  u2023_02_13_22_30_CreateChartOfAccountTable.Migration in 'Config\Migrations\u2023_02_13_22_30_CreateChartOfAccountTable.Migration.pas' {/ As vezes o uTestLoad.View da declaração das units acima é removido automaticamente},
  uPersonContact.Show.DTO in 'Module\General\Person\DTO\uPersonContact.Show.DTO.pas',
  uPayment.SQLBuilder.MySQL in 'Module\Financial\Payment\SQLBuilder\uPayment.SQLBuilder.MySQL.pas',
  uPayment.Mapper in 'Module\Financial\Payment\Mapper\uPayment.Mapper.pas',
  uPayment.Repository.SQL in 'Module\Financial\Payment\Repository\uPayment.Repository.SQL.pas',
  uPaymentTerm in 'Module\Financial\Payment\Domain\Entity\uPaymentTerm.pas',
  uPayment.Persistence.UseCase in 'Module\Financial\Payment\UseCase\uPayment.Persistence.UseCase.pas',
  uPayment.Test in 'Module\Financial\Payment\Test\uPayment.Test.pas',
  uPayment.SQLBuilder.Interfaces in 'Module\Financial\Payment\SQLBuilder\uPayment.SQLBuilder.Interfaces.pas',
  uPayment.Filter in 'Module\Financial\Payment\Filter\uPayment.Filter.pas',
  uPayment.Repository.Interfaces in 'Module\Financial\Payment\Repository\uPayment.Repository.Interfaces.pas',
  uPayment in 'Module\Financial\Payment\Domain\Entity\uPayment.pas',
  uPayment.DataFactory in 'Module\Financial\Payment\DataFactory\uPayment.DataFactory.pas',
  uPayment.Filter.DTO in 'Module\Financial\Payment\DTO\uPayment.Filter.DTO.pas',
  uPayment.Input.DTO in 'Module\Financial\Payment\DTO\uPayment.Input.DTO.pas',
  uPayment.Show.DTO in 'Module\Financial\Payment\DTO\uPayment.Show.DTO.pas',
  uPaymentTerm.Input.DTO in 'Module\Financial\Payment\DTO\uPaymentTerm.Input.DTO.pas',
  uPaymentTerm.Show.DTO in 'Module\Financial\Payment\DTO\uPaymentTerm.Show.DTO.pas',
  u2023_02_15_19_20_CreatePaymentTable.Migration in 'Config\Migrations\u2023_02_15_19_20_CreatePaymentTable.Migration.pas',
  u2023_02_15_19_20_CreatePaymentTermTable.Migration in 'Config\Migrations\u2023_02_15_19_20_CreatePaymentTermTable.Migration.pas',
  u2023_02_15_19_21_Payment.seeder in 'Config\Seeders\u2023_02_15_19_21_Payment.seeder.pas' {/ As vezes o uTestLoad.View da declaração das units acima é removido automaticamente},
  u2023_02_16_14_31_CreateSaleTable.Migration in 'Config\Migrations\u2023_02_16_14_31_CreateSaleTable.Migration.pas',
  u2023_02_16_14_32_CreateSaleItemTable.Migration in 'Config\Migrations\u2023_02_16_14_32_CreateSaleItemTable.Migration.pas',
  u2023_02_16_14_33_CreateSalePaymentTable.Migration in 'Config\Migrations\u2023_02_16_14_33_CreateSalePaymentTable.Migration.pas',
  uSale.SQLBuilder.MySQL in 'Module\Business\Sale\SQLBuilder\uSale.SQLBuilder.MySQL.pas',
  uSale.Mapper in 'Module\Business\Sale\Mapper\uSale.Mapper.pas',
  uSale.Repository.SQL in 'Module\Business\Sale\Repository\uSale.Repository.SQL.pas',
  uSaleItem in 'Module\Business\Sale\Domain\Entity\uSaleItem.pas',
  uSaleItem.Show.DTO in 'Module\Business\Sale\DTO\uSaleItem.Show.DTO.pas',
  uSale.Persistence.UseCase in 'Module\Business\Sale\UseCase\uSale.Persistence.UseCase.pas',
  uSale.Test in 'Module\Business\Sale\Test\uSale.Test.pas',
  uSale.SQLBuilder.Interfaces in 'Module\Business\Sale\SQLBuilder\uSale.SQLBuilder.Interfaces.pas',
  uSale.Repository.Interfaces in 'Module\Business\Sale\Repository\uSale.Repository.Interfaces.pas',
  uSale.Filter in 'Module\Business\Sale\Filter\uSale.Filter.pas',
  uSale.Input.DTO in 'Module\Business\Sale\DTO\uSale.Input.DTO.pas',
  uSale in 'Module\Business\Sale\Domain\Entity\uSale.pas',
  uSale.DataFactory in 'Module\Business\Sale\DataFactory\uSale.DataFactory.pas',
  uSale.Filter.DTO in 'Module\Business\Sale\DTO\uSale.Filter.DTO.pas',
  uSale.Show.DTO in 'Module\Business\Sale\DTO\uSale.Show.DTO.pas',
  uSaleItem.Input.DTO in 'Module\Business\Sale\DTO\uSaleItem.Input.DTO.pas',
  uSale.Types in 'Module\Business\Sale\Domain\Types\uSale.Types.pas',
  uSalePayment in 'Module\Business\Sale\Domain\Entity\uSalePayment.pas',
  uSale.BeforeSave in 'Module\Business\Sale\Domain\DomainService\uSale.BeforeSave.pas',
  uSalePayment.Input.DTO in 'Module\Business\Sale\DTO\uSalePayment.Input.DTO.pas',
  uBillPayReceive.SQLBuilder.MySQL in 'Module\Financial\BillPayReceive\SQLBuilder\uBillPayReceive.SQLBuilder.MySQL.pas',
  uBillPayReceive.Mapper in 'Module\Financial\BillPayReceive\Mapper\uBillPayReceive.Mapper.pas',
  uBillPayReceive.Persistence.UseCase in 'Module\Financial\BillPayReceive\UseCase\uBillPayReceive.Persistence.UseCase.pas',
  uBillPayReceive.Test in 'Module\Financial\BillPayReceive\Test\uBillPayReceive.Test.pas',
  uBillPayReceive.Repository.SQL in 'Module\Financial\BillPayReceive\Repository\uBillPayReceive.Repository.SQL.pas',
  uBillPayReceive.SQLBuilder.Interfaces in 'Module\Financial\BillPayReceive\SQLBuilder\uBillPayReceive.SQLBuilder.Interfaces.pas',
  uBillPayReceive.Repository.Interfaces in 'Module\Financial\BillPayReceive\Repository\uBillPayReceive.Repository.Interfaces.pas',
  uBillPayReceive.Filter in 'Module\Financial\BillPayReceive\Filter\uBillPayReceive.Filter.pas',
  uBillPayReceive in 'Module\Financial\BillPayReceive\Domain\Entity\uBillPayReceive.pas',
  uBillPayReceive.Input.DTO in 'Module\Financial\BillPayReceive\DTO\uBillPayReceive.Input.DTO.pas',
  uBillPayReceive.Show.DTO in 'Module\Financial\BillPayReceive\DTO\uBillPayReceive.Show.DTO.pas',
  uBillPayReceive.Filter.DTO in 'Module\Financial\BillPayReceive\DTO\uBillPayReceive.Filter.DTO.pas',
  uBillPayReceive.DataFactory in 'Module\Financial\BillPayReceive\DataFactory\uBillPayReceive.DataFactory.pas',
  uBillPayReceive.Types in 'Module\Financial\BillPayReceive\Domain\Types\uBillPayReceive.Types.pas',
  uSalePayment.Show.DTO in 'Module\Business\Sale\DTO\uSalePayment.Show.DTO.pas',
  u2023_02_21_07_48_CreateBillPayReceiveTable.Migration in 'Config\Migrations\u2023_02_21_07_48_CreateBillPayReceiveTable.Migration.pas',
  u2023_02_26_12_47_CreateConsumptionTable.Migration in 'Config\Migrations\u2023_02_26_12_47_CreateConsumptionTable.Migration.pas',
  uConsumption.Persistence.UseCase in 'Module\General\Consumption\UseCase\uConsumption.Persistence.UseCase.pas',
  uConsumption.Test in 'Module\General\Consumption\Test\uConsumption.Test.pas',
  uConsumption.Repository.SQL in 'Module\General\Consumption\Repository\uConsumption.Repository.SQL.pas',
  uConsumption.SQLBuilder.Interfaces in 'Module\General\Consumption\SQLBuilder\uConsumption.SQLBuilder.Interfaces.pas',
  uConsumption.SQLBuilder.MySQL in 'Module\General\Consumption\SQLBuilder\uConsumption.SQLBuilder.MySQL.pas',
  uConsumption.Filter in 'Module\General\Consumption\Filter\uConsumption.Filter.pas',
  uConsumption.Mapper in 'Module\General\Consumption\Mapper\uConsumption.Mapper.pas',
  uConsumption.Repository.Interfaces in 'Module\General\Consumption\Repository\uConsumption.Repository.Interfaces.pas',
  uConsumption.DataFactory in 'Module\General\Consumption\DataFactory\uConsumption.DataFactory.pas',
  uConsumption.Filter.DTO in 'Module\General\Consumption\DTO\uConsumption.Filter.DTO.pas',
  uConsumption.Input.DTO in 'Module\General\Consumption\DTO\uConsumption.Input.DTO.pas',
  uConsumption in 'Module\General\Consumption\Domain\Entity\uConsumption.pas',
  uConsumption.Show.DTO in 'Module\General\Consumption\DTO\uConsumption.Show.DTO.pas',
  uConsumptionSale.Filter in 'Module\General\Consumption\Filter\uConsumptionSale.Filter.pas',
  u2023_03_06_13_01_CreateCashFlowTable.Migration in 'Config\Migrations\u2023_03_06_13_01_CreateCashFlowTable.Migration.pas',
  u2023_03_06_13_02_CreateCashFlowTransactionTable.Migration in 'Config\Migrations\u2023_03_06_13_02_CreateCashFlowTransactionTable.Migration.pas',
  uCashFlow.SQLBuilder.MySQL in 'Module\Financial\CashFlow\SQLBuilder\uCashFlow.SQLBuilder.MySQL.pas',
  uCashFlow.Mapper in 'Module\Financial\CashFlow\Mapper\uCashFlow.Mapper.pas',
  uCashFlow.Repository.SQL in 'Module\Financial\CashFlow\Repository\uCashFlow.Repository.SQL.pas',
  uCashFlowTransaction in 'Module\Financial\CashFlow\Domain\Entity\uCashFlowTransaction.pas',
  uCashFlowTransaction.Show.DTO in 'Module\Financial\CashFlow\DTO\uCashFlowTransaction.Show.DTO.pas',
  uCashFlow.Persistence.UseCase in 'Module\Financial\CashFlow\UseCase\uCashFlow.Persistence.UseCase.pas',
  uCashFlow.Test in 'Module\Financial\CashFlow\Test\uCashFlow.Test.pas',
  uCashFlow.SQLBuilder.Interfaces in 'Module\Financial\CashFlow\SQLBuilder\uCashFlow.SQLBuilder.Interfaces.pas',
  uCashFlow.Repository.Interfaces in 'Module\Financial\CashFlow\Repository\uCashFlow.Repository.Interfaces.pas',
  uCashFlow.Filter in 'Module\Financial\CashFlow\Filter\uCashFlow.Filter.pas',
  uCashFlow in 'Module\Financial\CashFlow\Domain\Entity\uCashFlow.pas',
  uCashFlow.Show.DTO in 'Module\Financial\CashFlow\DTO\uCashFlow.Show.DTO.pas',
  uCashFlow.DataFactory in 'Module\Financial\CashFlow\DataFactory\uCashFlow.DataFactory.pas',
  uCashFlow.Filter.DTO in 'Module\Financial\CashFlow\DTO\uCashFlow.Filter.DTO.pas',
  uCashFlow.Input.DTO in 'Module\Financial\CashFlow\DTO\uCashFlow.Input.DTO.pas',
  uCashFlowTransaction.Input.DTO in 'Module\Financial\CashFlow\DTO\uCashFlowTransaction.Input.DTO.pas' {/ As vezes o uTestLoad.View da declaração das units acima é removido automaticamente},
  uSale.GenerateBilling.UseCase in 'Module\Business\Sale\UseCase\uSale.GenerateBilling.UseCase.pas',
  uTestConnection in 'Config\uTestConnection.pas',
  uSale.GenerateBillReceivesBySale in 'Module\Business\Sale\Domain\DomainService\uSale.GenerateBillReceivesBySale.pas',
  uCashFlowTransaction.Types in 'Module\Financial\CashFlow\Domain\Types\uCashFlowTransaction.Types.pas',
  uSale.GenerateCashFlowTransactionsBySale in 'Module\Business\Sale\Domain\DomainService\uSale.GenerateCashFlowTransactionsBySale.pas',
  uSaleGenerateBillingRepositories in 'Module\Business\Sale\Facade\uSaleGenerateBillingRepositories.pas' {/ As vezes o uTestLoad.View da declaração das units acima é removido automaticamente},
  uTrans.Sale in 'Shared\Resources\uTrans.Sale.pas',
  uTrans.Types in 'Shared\Resources\uTrans.Types.pas' {/ As vezes o uTestLoad.View da declaração das units acima é removido automaticamente},
  uSale.PdfReport.UseCase in 'Module\Business\Sale\UseCase\uSale.PdfReport.UseCase.pas',
  uOutPutFileStream in 'Shared\Util\uOutPutFileStream.pas',
  uBase.Report in 'Shared\Report\uBase.Report.pas' {BaseReport},
  uSale.Report in 'Module\Business\Sale\Report\uSale.Report.pas' {SaleReport},
  uAclRole.Types in 'Module\Auth\AclRole\Domain\Types\uAclRole.Types.pas',
  uAclRole.Persistence.UseCase.Interfaces in 'Module\Auth\AclRole\UseCase\uAclRole.Persistence.UseCase.Interfaces.pas',
  uAclUser.Persistence.UseCase.Interfaces in 'Module\Auth\AclUser\UseCase\uAclUser.Persistence.UseCase.Interfaces.pas',
  uBank.Persistence.UseCase.Interfaces in 'Module\Financial\Bank\UseCase\uBank.Persistence.UseCase.Interfaces.pas',
  uBankAccount.Persistence.UseCase.Interfaces in 'Module\Financial\BankAccount\UseCase\uBankAccount.Persistence.UseCase.Interfaces.pas',
  uBillPayReceive.Persistence.UseCase.Interfaces in 'Module\Financial\BillPayReceive\UseCase\uBillPayReceive.Persistence.UseCase.Interfaces.pas',
  uCashFlow.Persistence.UseCase.Interfaces in 'Module\Financial\CashFlow\UseCase\uCashFlow.Persistence.UseCase.Interfaces.pas',
  uCategory.Persistence.UseCase.Interfaces in 'Module\Stock\Category\UseCase\uCategory.Persistence.UseCase.Interfaces.pas',
  uChartOfAccount.Persistence.UseCase.Interfaces in 'Module\Financial\ChartOfAccount\UseCase\uChartOfAccount.Persistence.UseCase.Interfaces.pas',
  uCity.Persistence.UseCase.Interfaces in 'Module\General\City\UseCase\uCity.Persistence.UseCase.Interfaces.pas',
  uCompany.Persistence.UseCase.Interfaces in 'Module\General\Company\UseCase\uCompany.Persistence.UseCase.Interfaces.pas',
  uConsumption.Persistence.UseCase.Interfaces in 'Module\General\Consumption\UseCase\uConsumption.Persistence.UseCase.Interfaces.pas',
  uCostCenter.Persistence.UseCase.Interfaces in 'Module\Financial\CostCenter\UseCase\uCostCenter.Persistence.UseCase.Interfaces.pas',
  uNcm.Persistence.UseCase.Interfaces in 'Module\Stock\Ncm\UseCase\uNcm.Persistence.UseCase.Interfaces.pas',
  uPayment.Persistence.UseCase.Interfaces in 'Module\Financial\Payment\UseCase\uPayment.Persistence.UseCase.Interfaces.pas',
  uPerson.Persistence.UseCase.Interfaces in 'Module\General\Person\UseCase\uPerson.Persistence.UseCase.Interfaces.pas',
  uProduct.Persistence.UseCase.Interfaces in 'Module\Stock\Product\UseCase\uProduct.Persistence.UseCase.Interfaces.pas',
  uSale.Persistence.UseCase.Interfaces in 'Module\Business\Sale\UseCase\uSale.Persistence.UseCase.Interfaces.pas',
  uSize.Persistence.UseCase.Interfaces in 'Module\Stock\Size\UseCase\uSize.Persistence.UseCase.Interfaces.pas',
  uStation.Persistence.UseCase.Interfaces in 'Module\General\Station\UseCase\uStation.Persistence.UseCase.Interfaces.pas',
  uStorageLocation.Persistence.UseCase.Interfaces in 'Module\Stock\StorageLocation\UseCase\uStorageLocation.Persistence.UseCase.Interfaces.pas',
  uUnit.Persistence.UseCase.Interfaces in 'Module\Stock\Unit\UseCase\uUnit.Persistence.UseCase.Interfaces.pas',
  uBrand.Persistence.UseCase.Interfaces in 'Module\Stock\Brand\UseCase\uBrand.Persistence.UseCase.Interfaces.pas',
  uQueueEmail.SendPending.UseCase in 'Module\General\QueueEmail\UseCase\uQueueEmail.SendPending.UseCase.pas',
  uQueueEmailAttachment in 'Module\General\QueueEmail\Domain\Entity\uQueueEmailAttachment.pas',
  uQueueEmail.Types in 'Module\General\QueueEmail\Domain\Types\uQueueEmail.Types.pas',
  uQueueEmail.Repository.SQL in 'Module\General\QueueEmail\Repository\uQueueEmail.Repository.SQL.pas',
  uQueueEmail.SQLBuilder.MySQL in 'Module\General\QueueEmail\SQLBuilder\uQueueEmail.SQLBuilder.MySQL.pas',
  uQueueEmail.Mapper in 'Module\General\QueueEmail\Mapper\uQueueEmail.Mapper.pas',
  uQueueEmailAttachment.Show.DTO in 'Module\General\QueueEmail\DTO\uQueueEmailAttachment.Show.DTO.pas',
  uQueueEmailContact.Show.DTO in 'Module\General\QueueEmail\DTO\uQueueEmailContact.Show.DTO.pas',
  uQueueEmailContact in 'Module\General\QueueEmail\Domain\Entity\uQueueEmailContact.pas',
  uQueueEmail.Persistence.UseCase in 'Module\General\QueueEmail\UseCase\uQueueEmail.Persistence.UseCase.pas',
  uQueueEmail.Persistence.UseCase.Interfaces in 'Module\General\QueueEmail\UseCase\uQueueEmail.Persistence.UseCase.Interfaces.pas',
  uQueueEmail.Test in 'Module\General\QueueEmail\Test\uQueueEmail.Test.pas',
  uQueueEmail.Repository.Interfaces in 'Module\General\QueueEmail\Repository\uQueueEmail.Repository.Interfaces.pas',
  uQueueEmail.SQLBuilder.Interfaces in 'Module\General\QueueEmail\SQLBuilder\uQueueEmail.SQLBuilder.Interfaces.pas',
  uQueueEmail.Filter in 'Module\General\QueueEmail\Filter\uQueueEmail.Filter.pas',
  uQueueEmailContact.Input.DTO in 'Module\General\QueueEmail\DTO\uQueueEmailContact.Input.DTO.pas',
  uQueueEmail.Filter.DTO in 'Module\General\QueueEmail\DTO\uQueueEmail.Filter.DTO.pas',
  uQueueEmail.Input.DTO in 'Module\General\QueueEmail\DTO\uQueueEmail.Input.DTO.pas',
  uQueueEmail.Show.DTO in 'Module\General\QueueEmail\DTO\uQueueEmail.Show.DTO.pas',
  uQueueEmail.DataFactory in 'Module\General\QueueEmail\DataFactory\uQueueEmail.DataFactory.pas',
  uQueueEmail in 'Module\General\QueueEmail\Domain\Entity\uQueueEmail.pas',
  uQueueEmailAttachment.Input.DTO in 'Module\General\QueueEmail\DTO\uQueueEmailAttachment.Input.DTO.pas',
  u2023_05_12_00_25_CreateQueueEmailTable.Migration in 'Config\Migrations\u2023_05_12_00_25_CreateQueueEmailTable.Migration.pas',
  u2023_05_12_00_26_CreateQueueEmailAttachmentTable.Migration in 'Config\Migrations\u2023_05_12_00_26_CreateQueueEmailAttachmentTable.Migration.pas',
  u2023_05_12_00_27_CreateQueueEmailContactTable.Migration in 'Config\Migrations\u2023_05_12_00_27_CreateQueueEmailContactTable.Migration.pas',
  u2023_02_11_23_35_Company.seeder in 'Config\Seeders\u2023_02_11_23_35_Company.seeder.pas',
  uCache in 'Config\uCache.pas';

// As vezes o uTestLoad.View da declaração das units acima é removido automaticamente
// Se isso ocorrer, copie o código abaixo e substitua manualmente
// ....
//  {$IFDEF TESTINSIGHT}
//  TestInsight.DUnitX,
//  uTestLoad.View in 'Config\uTestLoad.View.pas' {TestLoadView},
//  {$ENDIF }
// ...

const
  RECREATE_DATABASE = True; // FLAG PARA RECRIAR O BANCO DE DADOS

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger: ITestLogger;
  startTime: Cardinal;
  duration: Double;
  canConsoleWrite: Boolean;

  procedure RunMigrationAndSeeds;
  begin
    {$IFDEF TESTINSIGHT}
    if RECREATE_DATABASE then
    begin
      TestLoadView := TTestLoadView.Create(nil);
      TestLoadView.Show;
      TestLoadView.Refresh;
    end;
    {$ENDIF}

    if RECREATE_DATABASE then
    begin
      With TConnectionFactory.Make.MakeScript do
      begin
        // Recriar base de dados. Necessário existência do banco
        SQLScriptsClear.SQLScriptsAdd('DROP DATABASE IF EXISTS '+ENV_REST.Database).ExecuteAll;
        SQLScriptsClear.SQLScriptsAdd('CREATE DATABASE '        +ENV_REST.Database).ExecuteAll;
        if canConsoleWrite then System.Writeln('Recreated database!');
      end;
    end;

    // Rodar Migrações e Seeders
    if canConsoleWrite then System.Writeln('Running migrations and seeders...');
    ConnMigration.RunPendingMigrationsAndSeeders;

    {$IFDEF TESTINSIGHT}
    if RECREATE_DATABASE then
    begin
      TestLoadView.Hide;
      TestLoadView.Free;
    end;
    {$ENDIF}
  end;

  procedure ClearTempFolder;
  begin
    const lTempPath = ExtractFilePath(ParamStr(0)) + 'Temp\';
    if TDirectory.Exists(lTempPath) then
      TDirectory.Delete(lTempPath, True);
  end;

begin
  ClearTempFolder;
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := TCaseNameDefinition.cndLower;
  ReportMemoryLeaksOnShutdown := True;

{$IFDEF TESTINSIGHT}
  RunMigrationAndSeeds;
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}

  try
    startTime := GetTickCount;
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;
    canConsoleWrite := TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause;

    // Rodar Migrações e Seeds
    RunMigrationAndSeeds;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if canConsoleWrite then
    begin
      duration := (GetTickCount - startTime)/1000;
      System.WriteLn('Duration: ' + duration.ToString + ' seconds.');
      System.WriteLn('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
