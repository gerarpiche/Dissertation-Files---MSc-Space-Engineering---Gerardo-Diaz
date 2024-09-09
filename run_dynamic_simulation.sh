#!/bin/bash
set -x

# Variables from controlDict
startTime=0
endTime=0.0002
deltaT=0.000001
caseDir="/INDICATE_YOUR_CASE_DIR"

# Change to the case directory
cd $caseDir

# Start the time loop
currentTime=$startTime
while (( $(echo "$currentTime <= $endTime" | bc -l) )); do
    # Format currentTime and nextTime in scientific notation
    currentTimeFormatted=$(printf "%.2e" $currentTime)

    # Update controlDict file
    sed -i "s/^startTime.*;/startTime $currentTimeFormatted;/g" system/controlDict 
    sed -i "s/^endTime.*;/endTime $(printf "%.2e" $(echo "$currentTime + $deltaT" | bc));/g" system/controlDict

    # Run dsmcFoamPlus for the current time step
    dsmcFoam >> log.dsmcFoam

    # Run moveDynamicMesh to update the mesh
    moveDynamicMesh >> log.moveDynamicMesh

    # Format time folders
    nextTime=$(echo "$currentTime + $deltaT" | bc -l)
    nextTimeFormatted=$(printf "%.e" $nextTime)
    nextTimeOneFormatted=$(printf "%.1e" $nextTime)
    nextTimeTwoFormatted=$(printf "%.3f" $nextTime)
    nextTimeThreeFormatted=$(printf "%.4f" $nextTime)
    nextTimeFourFormatted=$(printf "%.5f" $nextTime)
    nextTimeFiveFormatted=$(printf "%.6f" $nextTime)

    cp -r $caseDir/$nextTimeFormatted/polyMesh/points $caseDir/constant/polyMesh/ > /dev/null 2>&1
    cp -r $caseDir/$nextTimeFormatted/* $caseDir/0/ > /dev/null 2>&1

    cp -r $caseDir/$nextTimeOneFormatted/polyMesh/points $caseDir/constant/polyMesh/ > /dev/null 2>&1
    cp -r $caseDir/$nextTimeOneFormatted/* $caseDir/0/ > /dev/null 2>&1

    cp -r $caseDir/$nextTimeTwoFormatted/polyMesh/points $caseDir/constant/polyMesh/ > /dev/null 2>&1
    cp -r $caseDir/$nextTimeTwoFormatted/* $caseDir/0/ > /dev/null 2>&1

    cp -r $caseDir/$nextTimeThreeFormatted/polyMesh/points $caseDir/constant/polyMesh/ > /dev/null 2>&1
    cp -r $caseDir/$nextTimeThreeFormatted/* $caseDir/0/ > /dev/null 2>&1

    cp -r $caseDir/$nextTimeFourFormatted/polyMesh/points $caseDir/constant/polyMesh/ > /dev/null 2>&1
    cp -r $caseDir/$nextTimeFourFormatted/* $caseDir/0/ > /dev/null 2>&1

    cp -r $caseDir/$nextTimeFiveFormatted/polyMesh/points $caseDir/constant/polyMesh/ > /dev/null 2>&1
    cp -r $caseDir/$nextTimeFiveFormatted/* $caseDir/0/ > /dev/null 2>&1



    # Update currentTime
    currentTime=$nextTime
done


echo "Simulation completed!"