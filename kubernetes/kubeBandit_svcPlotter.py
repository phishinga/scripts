import os
import yaml
import pygraphviz as pgv

# Create a new graph
G = pgv.AGraph(directed=True, strict=True, rankdir='LR', compound=True, nodesep=0.1, ranksep=0.1)

# Directory where the YAML files are located
yaml_directory = './pods/'

def has_subgraph(graph, name):
    for subgraph in graph.subgraphs():
        if subgraph.name == name:
            return True
    return False

# List to store the relationships
relationships = []

def visualize_service(yaml_file):
    external_ip = yaml_file['status'].get('loadBalancer', {}).get('ingress', [{}])[0].get('ip', 'N/A')
    selector = yaml_file['spec'].get('selector', {})
    if selector:
        selector_key, selector_value = list(selector.items())[0]
    else:
        selector_key, selector_value = 'N/A', 'N/A'
    
    # Add the external IP node and edge only if the external IP is not 'N/A'
    if external_ip != 'N/A':
        # Add the external IP node
        G.add_node(external_ip, shape='ellipse', color='blue', label=f"External IP: {external_ip}")
        
        # Loop through all nodes in the graph
        for node in G.nodes():
            # If the node's name contains the selector value, add an edge from the external IP to the node
            if selector_value in node:
                G.add_edge(external_ip, node, color='blue')

        # Loop through all nodes in the graph
        for node in G.nodes():
            # If the node's name starts with the selector value, add an edge from the external IP to the node
            if node.startswith(selector_value):
                G.add_edge(external_ip, node, color='blue')



# Loop through all the YAML files
for filename in os.listdir(yaml_directory):
    if filename.endswith(".yaml"):
        with open(os.path.join(yaml_directory, filename), 'r') as file:  # Open the YAML file and convert it to a Python dictionary
            yaml_file = yaml.safe_load(file)

            kind = yaml_file.get('kind', '')
            
            if kind == 'Service':
                visualize_service(yaml_file)
            elif kind == 'Pod':
                # Extract namespace and pod
                namespace = yaml_file['metadata']['namespace']
                pod = yaml_file['metadata']['name']
                podip = yaml_file['status'].get('podIP', 'N/A') # Get pod IP or 'N/A' if not found

                # Check if namespace cluster already exists, if not create one
                if not has_subgraph(G, 'cluster_' + namespace):
                    G.add_subgraph(name='cluster_' + namespace, label=namespace, shape='box', style='filled', color='lightgrey')

                # Retrieve the subgraph and set its attributes
                subgraph = G.get_subgraph("cluster_" + namespace)

                # Add the pod to the namespace cluster
                G.get_subgraph('cluster_' + namespace).add_node(pod, label=f"{pod}\n{podip}")

# After all files have been processed, create the edges
for external_ip, selector_value in relationships:
    for node in G.nodes():
        # If the node's name starts with the selector value, add an edge from the external IP to the node
        if node.startswith(selector_value):
            G.add_edge(external_ip, node, color='blue', len=0.1)

# Save and visualize the graph
G.layout(prog='dot')
G.draw('k8s_svc_graph.png', prog='dot', format='png')
