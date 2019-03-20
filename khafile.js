let project = new Project('Arena');
project.addAssets('Assets/**');
project.addSources('Sources');

// Own libraries 
project.addLibrary('gameTools');
project.addLibrary('physics');

// Public libraries
project.addLibrary('glm');
resolve(project);