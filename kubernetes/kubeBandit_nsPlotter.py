import os
import yaml
import pygraphviz as pgv

# Create a new graph
G = pgv.AGraph(directed=True, strict=True, rankdir='LR', compound=True)

# Directory where the YAML files are located
yaml_directory = './pods/'

def has_subgraph(graph, name):
    for subgraph in graph.subgraphs():
        if subgraph.name == name:
            return True
    return False

# Loop through all the YAML files
for filename in os.listdir(yaml_directory):
    if filename.endswith(".yaml"):
        # Open the YAML file and convert it to a Python dictionary
        with open(os.path.join(yaml_directory, filename), 'r') as file:
            yaml_file = yaml.safe_load(file)

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

# Save and visualize the graph
G.layout(prog='fdp')
G.draw('k8s_graph.png', prog='fdp', format='png')
