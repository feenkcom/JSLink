Extension { #name : #LanguageLinkSettings }

{ #category : #'*JSLink' }
LanguageLinkSettings class >> jsDefaultSettings [

	^ self new 
		clientSocketAddress: (LanguageLinkSocketAddress 
				ipOrName: 'localhost' port: (7000 + 99 atRandom));
		serverSocketAddress: (LanguageLinkSocketAddress 
				ipOrName: 'localhost' port: (6900 + 99 atRandom));
		messageBrokerStrategy: LanguageLinkHttpMessageBroker;
		serverProcessClass: JSLinkPharoNodejsProcess;
		platform: JSLinkPharoPlatform new;
		commandFactoryClass: JSLinkCommandFactory;
		commandClass: LanguageLinkCommand;
		serializerClass: LanguageLinkSerializer;
		deserializerClass: JSLinkDeserializer;
		parserClass: JSParser;
		yourself
]
