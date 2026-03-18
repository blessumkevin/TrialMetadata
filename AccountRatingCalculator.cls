/**
 * @description Calculates and updates Account Rating (Hot/Warm/Cold) based on business criteria
 * including Annual Revenue, Number of Employees, and related Opportunities count.
 * Uses a point-based scoring system to determine the appropriate rating.
 * 
 * @author Salesforce Developer
 * @date 2026
 */
public with sharing class AccountRatingCalculator {
    
    /**
     * @description Calculate and update rating for a single account
     * @param accountId The ID of the Account to update
     * @throws SecurityException if user lacks necessary permissions
     */
    public static void updateAccountRating(Id accountId) {
        validatePermissions();
        
        Account acc = [SELECT Id, AnnualRevenue, NumberOfEmployees, 
                       (SELECT Id FROM Opportunities) 
                       FROM Account WHERE Id = :accountId
                       WITH SECURITY_ENFORCED];
        
        acc.Rating = calculateRating(acc.AnnualRevenue, acc.NumberOfEmployees, acc.Opportunities.size());
        
        validateFieldPermissions();
        
        update acc;
    }
    
    /**
     * @description Calculate and update ratings for multiple accounts
     * @param accountIds List of Account IDs to update
     * @throws SecurityException if user lacks necessary permissions
     */
    public static void updateAccountRatings(List<Id> accountIds) {
        validatePermissions();
        
        List<Account> accounts = [SELECT Id, AnnualRevenue, NumberOfEmployees,
                                  (SELECT Id FROM Opportunities)
                                  FROM Account WHERE Id IN :accountIds
                                  WITH SECURITY_ENFORCED];
        
        validateFieldPermissions();
        
        for (Account acc : accounts) {
            acc.Rating = calculateRating(acc.AnnualRevenue, acc.NumberOfEmployees, acc.Opportunities.size());
        }
        
        update accounts;
    }
    
    /**
     * @description Validate object-level CRUD permissions for Account
     * @throws SecurityException if user lacks necessary permissions
     */
    private static void validatePermissions() {
        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new SecurityException('Insufficient permissions to read Account records');
        }
        
        if (!Schema.sObjectType.Account.isUpdateable()) {
            throw new SecurityException('Insufficient permissions to update Account records');
        }
    }
    
    /**
     * @description Validate field-level security for Rating field
     * @throws SecurityException if user lacks necessary permissions
     */
    private static void validateFieldPermissions() {
        if (!Schema.sObjectType.Account.fields.Rating.isUpdateable()) {
            throw new SecurityException('Insufficient permissions to update Rating field');
        }
    }
    
    /**
     * @description Core rating calculation logic using point-based scoring
     * @param revenue Annual Revenue of the Account
     * @param employees Number of Employees
     * @param oppCount Number of related Opportunities
     * @return String Rating value: 'Hot', 'Warm', or 'Cold'
     */
    private static String calculateRating(Decimal revenue, Integer employees, Integer oppCount) {
        Integer score = 0;
        
        score += calculateRevenueScore(revenue);
        score += calculateEmployeeScore(employees);
        score += calculateOpportunityScore(oppCount);
        
        return determineRatingFromScore(score);
    }
    
    /**
     * @description Calculate score based on Annual Revenue
     * @param revenue Annual Revenue of the Account
     * @return Integer Score between 0-3
     */
    private static Integer calculateRevenueScore(Decimal revenue) {
        if (revenue == null) {
            return 0;
        }
        
        if (revenue >= 10000000) {
            return 3;  // $10M+
        } else if (revenue >= 1000000) {
            return 2;  // $1M+
        } else if (revenue >= 100000) {
            return 1;  // $100K+
        }
        
        return 0;
    }
    
    /**
     * @description Calculate score based on Number of Employees
     * @param employees Number of Employees
     * @return Integer Score between 0-3
     */
    private static Integer calculateEmployeeScore(Integer employees) {
        if (employees == null) {
            return 0;
        }
        
        if (employees >= 500) {
            return 3;
        } else if (employees >= 100) {
            return 2;
        } else if (employees >= 10) {
            return 1;
        }
        
        return 0;
    }
    
    /**
     * @description Calculate score based on Opportunity count
     * @param oppCount Number of related Opportunities
     * @return Integer Score between 0-3
     */
    private static Integer calculateOpportunityScore(Integer oppCount) {
        if (oppCount >= 5) {
            return 3;
        } else if (oppCount >= 2) {
            return 2;
        } else if (oppCount >= 1) {
            return 1;
        }
        
        return 0;
    }
    
    /**
     * @description Determine rating based on total score
     * @param score Total score (0-9)
     * @return String Rating value: 'Hot', 'Warm', or 'Cold'
     */
    private static String determineRatingFromScore(Integer score) {
        if (score >= 7) {
            return 'Hot';
        } else if (score >= 3) {
            return 'Warm';
        } else {
            return 'Cold';
        }
    }
    
    /**
     * @description Custom exception for security violations
     */
    public class SecurityException extends Exception {}
}
