from azure.mgmt.resourcegraph import ResourceGraphClient,models
from azure.identity import DefaultAzureCredential


default_credential = DefaultAzureCredential()
resource_graph_client = ResourceGraphClient(default_credential)

def ARGQuery(query: str, subscription_ids: list[str]):
        
        queryrequest = models.QueryRequest(
            subscriptions=subscription_ids,
            query = query )
        data = resource_graph_client.resources(queryrequest) 
        return data


def main():
        example = ARGQuery(query= "resources | where ['type'] == 'microsoft.compute/virtualmachines'", 
                           subscription_ids=[""] )
        print(example)


main()
