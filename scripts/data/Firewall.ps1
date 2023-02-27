$Files = @(
	@{
		Path  = "${Env:ProgramFiles(x86)}\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe"
		Check = $False
	},
	@{ 
		Path  = "$Env:ProgramFiles\Common Files\Adobe\Adobe Desktop Common\NGL\adobe_licensing_wf.exe"
		Check = $False
	},
	@{
		Path  = "$Env:ProgramFiles\Common Files\Adobe\Adobe Desktop Common\NGL\adobe_licensing_wf_helper.exe"
		Check = $False
	}
)