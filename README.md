# Geodesic Icosphere

A novel approach to generating arbitrary resolution icosphere meshes in a single compute kernel dispatch. Creates a buffer of vertex points and a buffer of triangle indices for the mesh itself. Also creates a buffer of neighbours for each vertex, encoding the count of neighbours into the `w` coord of each vertex (12 vertices have only 5 neighbours in any icosphere). 

Developed as the foundation for [my world generator, Rock 3](https://store.steampowered.com/app/1892520/Rock_3/).
