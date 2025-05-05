public class AccountAutomations {
    public static Account setDefaultDescription(Account a) {
        if (a.Description != null) return a;
        else {
            a.Description = 'Default description';
            return a;
        }
    }

    public static Account setDefaultBillingAddress(Account a) {
        a.billingstreet = '123 Main St'; 
        a.billingstate = 'CA'; 
        a.billingpostalcode = '90210'; 
        a.billingcountry = 'USA';
        return a;
    }

    public static Account setDefaultShippingAddress(Account a) {
        a.shippingstreet = '123 Main St'; 
        a.shippingstate = 'CA';
        a.shippingpostalcode = '90210';
        a.shippingcountry = 'USA';
        return a;
    }

    public static Account setDefaultPhone(Account a) {
        a.Phone = '5555555555';
        return a;
    }

    public static Account setDefaultURL(Account a) {
        a.website = 'www.copa.do'; 
        return a;
    }
}
