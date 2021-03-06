package pt.iflow.api.licensing;


/**
 * Usa a base de dados como suporte para registo das
 * 
 * @author ombl
 * 
 */
public class NoLicenseServiceFactory extends LicenseServiceFactory {

  private static final NoLicenseService SERVICE = new NoLicenseService();
  //Descomentar para desabilitar as licenças
  //private static final NoLicenseService SERVICE = new NoLicenseService();

  protected LicenseService doGetLicenseService() {
    return SERVICE;
  }
  
  
}
