<cfcomponent output="no">

	<cffunction name="getUserData" access="remote" returntype="query" returnformat="json">
		
		<cfscript>
			return this.getWhosOn().whosOnline();
		</cfscript>
		
	</cffunction>
	
	<cffunction name="getWhosOn" access="private" returntype="any">
		<cfreturn application.whoson />
	</cffunction>
	
</cfcomponent>