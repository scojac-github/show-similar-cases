public with sharing class SimilarCaseController {

    @AuraEnabled(cacheable=true)
    public static List<Case> getSimilarCases(String caseId) {
        List<Case> caseList = new List<Case>();

        // Get subject from Case
        Case caseRecord = [SELECT Subject, Type FROM Case WHERE Id = :caseId];

        // Define common words to exclude. Add more as needed
        Set<String> commonWords = new Set<String>{'and', 'the', 'for', 'it', 'is', 'in', 'of', 'with', 'on'};

        // Search all keywords by inserting 'OR' operator between each word, excluding common words
        List<String> filteredStringList = new List<String>();
        for(String word : caseRecord.Subject.split(' ')){
            if(!commonWords.contains(word.toLowerCase())){
                filteredStringList.add(word);
            }
        }

        // Build search term
        String stringSearch = String.join(filteredStringList, ' OR ') + '*';
        System.debug('Search for the following keywords: ' + stringSearch);

        // Get similar Cases
        List<List<SObject>> searchList = [
            FIND :stringSearch
            IN ALL FIELDS
            RETURNING
                Case(
                    Id,
                    CaseNumber,
                    Subject,
                    Type
                    WHERE Id != :caseId AND Type = :caseRecord.Type
                    ORDER BY CreatedDate DESC
                    LIMIT 5)
        ];

        system.debug(searchList);

        if (searchList.size() > 0) {
            return searchList[0];
        }
        return caseList;
    }
}