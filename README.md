# nes-pipeline [![Build Status](https://dev.azure.com/hxlnt/nes-pipeline/_apis/build/status/hxlnt.nes-pipeline?branchName=master)](https://dev.azure.com/hxlnt/nes-pipeline/_build/latest?definitionId=3&branchName=master)
It's continuous integration for NES homebrew with automagic screenshot updating! 

<figure>
  <img style="image-rendering: pixelated;" alt="Screenshot" width="512" src="https://raw.githubusercontent.com/hxlnt/nes-pipeline/master/build/screenshot.png">
<figcaption>Screenshot updated Wednesday, April 15, 2020 at 17:55:18 UTC+00:00.</figcaption>
</figure>

# How it works

Every time code is checked in to the `master` branch, an Azure Pipelines (free tier) workflow is automatically triggered. This workflow compiles the NES ROM from source, screenshots the ROM, updates the screenshot in the README, and posts everything back to GitHub with updated timestamps.

This example also edits the NES source on each run to add a timestamp to the NES screen itself, just to prove out the inner workings.

To try it out yourself, simply fork this repo, set up an Azure Pipeline, and connect the pipeline to your fork. If you want the pipeline and build badge to be publicly visible, make sure to change the default pipeline setting from private to public. Edit `azure-pipeline.yml` to change the build steps to suit your own workflow.

xoxox hxlnt ([rachel](https://twitter.com/partytimehxlnt))
