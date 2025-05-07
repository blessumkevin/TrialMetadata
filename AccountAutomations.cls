public class AccountAutomations {
    public static Account setDefaultDescription(Account a) {
        if (a.Description != null) return a;
        else {
            a.Description = 'Default description';
            return a;
        }
    }

    public static Account setDefaultBillingAddress(Account a) {
        a.billingstreet = '456 W Madison St'; 
        a.billingstate = 'IL'; 
        a.billingpostalcode = '60661'; 
        a.billingcountry = 'USA';
        return a;
    }

    public static Account setDefaultShippingAddress(Account a) {
        a.shippingstreet = '456 W Madison St'; 
        a.shippingstate = 'IL';
        a.shippingpostalcode = '60661';
        a.shippingcountry = 'USA';
        return a;
    }

    public static Account setDefaultPhone(Account a) {
        a.Phone = '9257868477';
        return a;
    }

    public static Account setDefaultURL(Account a) {
        a.website = 'www.copado.com'; 
        return a;
    }
}
