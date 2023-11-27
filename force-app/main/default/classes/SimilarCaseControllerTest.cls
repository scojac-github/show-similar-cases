@isTest
public class SimilarCaseControllerTest {

    // Test method to cover the getSimilarCases method
    @isTest
    static void testGetSimilarCases() {
        // Create a test Case
        Case testCase = new Case(Subject='Test Subject', Type='Test Type');
        insert testCase;

        // Call the getSimilarCases method in SimilarCaseController
        List<Case> resultCases = SimilarCaseController.getSimilarCases(testCase.Id);

        // Add assertions to ensure the expected behavior
        System.assertNotEquals(null, resultCases, 'Result should not be null');

        // Clean up test data
        delete testCase;
    }

    // Test method to cover scenarios where no similar cases are found
    @isTest
    static void testGetSimilarCasesNoResults() {
        // Create a test Case with a unique subject
        Case testCase = new Case(Subject='Unique Subject', Type='Test Type');
        insert testCase;

        // Call the getSimilarCases method in SimilarCaseController
        List<Case> resultCases = SimilarCaseController.getSimilarCases(testCase.Id);

        // Add assertions to ensure the expected behavior when no similar cases are found
        System.assertEquals(0, resultCases.size(), 'Result should be an empty list');

        // Clean up test data
        delete testCase;
    }

    // Test method to cover scenarios where the provided caseId is invalid
    @isTest
    static void testGetSimilarCasesInvalidCaseId() {
        
        // Call the getSimilarCases method with an invalid caseId
        List<Case> resultCases = SimilarCaseController.getSimilarCases('invalidId');

        // Add assertions to ensure the expected behavior when an invalid caseId is provided
        System.assertEquals(0, resultCases.size(), 'Result should be an empty list');
    }
}
