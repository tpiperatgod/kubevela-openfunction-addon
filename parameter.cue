package main

parameter: {
	//+usage=Namespace to deploy to, defaults to openfunction
	namespace:           *"openfunction" | string
	namespacePrefix:     *"ofn" | string
	kedaNamespace:       *(namespacePrefix + "-keda") | string
	daprNamespace:       *(namespacePrefix + "-dapr") | string
	tektonNamespace:     *(namespacePrefix + "-tekton") | string
	shipwrightNamespace: *(namespacePrefix + "-shipwright") | string
}
