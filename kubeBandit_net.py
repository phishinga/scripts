import yaml
import networkx as nx
import matplotlib.pyplot as plt
import os
import fnmatch

# Get a list of all files in the directory
directory_path = '/path/to/your/directory'  # Replace with the path to your directory
all_files = os.listdir(directory_path)

# Filter for YAML files
yaml_files = [file for file in all_files if fnmatch.fnmatch(file, '*.yaml')]

# Process each YAML file
for yaml_file in yaml_files:
    # Parse the YAML file
    with open(os.path.join(directory_path, yaml_file), 'r') as file:
        k8s_data = yaml.safe_load(file)

    # Extract the relevant information
    release_name = k8s_data['metadata']['annotations']['meta.helm.sh/release-name']
    release_namespace = k8s_data['metadata']['annotations']['meta.helm.sh/release-namespace']
    network_policy = k8s_data['spec']['podSelector']['matchLabels']
    ingress_rules = k8s_data['spec'].get('ingress', [])
    egress_rules = k8s_data['spec'].get('egress', [])

    # Create a directed graph
    G = nx.DiGraph()

    # Add a node for the NetworkPolicy
    G.add_node(release_name)

    # Add nodes and edges for the ingress rules
    for rule in ingress_rules:
        for source in rule['from']:
            for key, value in source['podSelector']['matchLabels'].items():
                # Add a node for the source pod
                source_node = f"{key}: {value}"
                G.add_node(source_node)
                
                # Add an edge from the source pod to the selected pods
                G.add_edge(source_node, release_name)

    # Add nodes and edges for the egress rules
    for rule in egress_rules:
        for destination in rule['to']:
            for key, value in destination['podSelector']['matchLabels'].items():
                # Add a node for the destination pod
                destination_node = f"{key}: {value}"
                G.add_node(destination_node)
                
                # Add an edge from the selected pods to the destination pod
                G.add_edge(release_name, destination_node)

    # Draw the graph 
    pos = nx.spring_layout(G, k=0.2, seed=12)

    labels = {node: f"{node}\n{network_policy}" for node in G.nodes()}
    nx.draw(G, pos, labels=labels)

    ax = plt.gca()
    xlim = ax.get_xlim()
    ylim = ax.get_ylim()
    padding = 0.3
    ax.set_xlim(xlim[0] - padding, xlim[1] + padding)
    ax.set_ylim(ylim[0] - padding, ylim[1] + padding)

    plt.show()
