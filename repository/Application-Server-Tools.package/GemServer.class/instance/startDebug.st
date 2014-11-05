other
startDebug

	self ports do:[:each| self startDebugOn: each]
