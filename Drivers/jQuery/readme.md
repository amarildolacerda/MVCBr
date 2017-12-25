

/*

Sample creating RestClient to GET data from ODataBuilder
// AngularJs way

function sat_cfeController($scope, $location) {
    // create ODataBuilder to get resource
    var builder = createODataBuilder('', 'web_satcfe_estado');
    // where
       builder.Filter = 'id eq 1';
       builder.Orderby = 'dh_actual';

    var    rest = new RestClient(builder);  // inject builder   

    $scope.values = [];

    rest.GET(function (dados) {   // GET from OData
        $scope.values = dados.value;
        if (!$scope.$$phase) {
            $scope.$apply();
        }
    });



};
*/
