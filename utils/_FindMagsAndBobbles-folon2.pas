{
	This needs to be in '....\FO4Edit 3.1.3\Edit Scripts' for FO4Edit to find it
	Searches all REFR records for perk mags and bobbleheads and outputs simple json to message window
	Apply Filter first to restrict to only REFR records for speed
}
unit userscript;

var eName, shortname : string;
var indexSpc : integer;

// ak function findWorldDoor(maxdepth, cell, prevCells, targetWorld: integer,  IInterface, TStringList, integer) : IInterface;
// ak var 
// ak 	cellworld, pcell, wdoor, list, list2, listitem: IInterface;
// ak 	skipcell, i,j,k: integer;
// ak begin
// ak 	skipcell := 0;
// ak //	prevCells.Add(IntToStr(FixedFormID(cell)));
// ak 
// ak 	list2 := ChildGroup(cell);
// ak 	for k := 0 to ElementCount(list2) -1 do begin
// ak 		list := ElementByIndex(ChildGroup(cell), k);
// ak 		for i := 0 to  ElementCount(list) - 1 do begin
// ak 			listitem := ElementByIndex(list, i);
// ak 			if ElementExists(listitem, 'XTEL') then begin
// ak 				wdoor := LinksTo(ElementByPath(listitem, 'XTEL\Door'));
// ak 				pcell := LinksTo(ElementByName(wdoor,'Cell'));
// ak 				//folon new
// ak 				cellworld := LinksTo(ElementByName(pcell,'WorldSpace'));
// ak 				if FixedFormID(cellworld) = targetWorld then begin
// ak 					Result := wdoor;
// ak 					Exit;
// ak 				end;
// ak 				//folon new end
// ak 
// ak 				//if FixedFormID(cellworld) = targetWorld  or FixedFormID(pcell) = targetWorld then begin
// ak 				if FixedFormID(pcell) = targetWorld then begin
// ak 					Result := wdoor;
// ak 					Exit;
// ak 				end
// ak 				else begin
// ak 					if maxdepth < 1  then begin
// ak 						Continue;
// ak 					end;
// ak 					
// ak 					for j := 0 to prevCells.Count-1 do begin
// ak 						if prevCells[j] = IntToStr(FixedFormID(pcell)) then begin
// ak 							skipcell := 1;
// ak 						end;
// ak 					end;
// ak 					if skipcell > 0 then begin
// ak //						AddMessage('	skipping ' + IntToStr(FixedFormID(pcell) ));
// ak 					end
// ak 					else begin
// ak 						Result := findWorldDoor(maxdepth-1, pcell, prevCells, targetWorld);
// ak 						Exit;
// ak 					end;
// ak 				end;
// ak 			end;
// ak 		end;
// ak 	end;
// ak 	prevCells.Add(IntToStr(FixedFormID(cell)));
// ak 
// ak //didn't find any doors to worlds is there a marker instead?
// ak //doesn't work, exteriors sub cell (masspikeinterchangeext4, etc) have no doors to the 
// ak //commonwealth worldspace, and their worldx\y are correct for commonwealth anyway, and
// ak //weird interior cells (Vault 81, Parsons State Admin, etc) still don't get
// ak //picked up.
// ak //			if ElementExists(cell, 'XLCN') then begin
// ak //				wdoor := LinksTo(ElementByPath(cell, 'XLCN'));
// ak //				if ElementExists(wdoor, 'MNAM') then begin
// ak //					AddMessage('XLCN: ' + IntToHex(FixedFormID(wdoor),8));
// ak //					wdoor := LinksTo(ElementByPath(wdoor, 'MNAM'));
// ak //					AddMessage('MNAM: ' + IntToHex(FixedFormID(wdoor),8));
// ak //					AddMessage('XMRK: ' + GetElementEditValues(wdoor, 'XMRK'));
// ak //					AddMessage('FNAM: ' + GetElementEditValues(wdoor, 'FNAM'));
// ak //					AddMessage('FULL: ' + GetElementEditValues(wdoor, 'FULL'));
// ak //					AddMessage('TNAM: ' + GetElementEditValues(wdoor, 'TNAM'));
// ak //					AddMessage('XRDS: ' + GetElementEditValues(wdoor, 'XRDS'));
// ak //					AddMessage('EDID: ' + GetElementEditValues(wdoor, 'EDID'));
// ak //					AddMessage('Map Marker: ' + GetElementEditValues(ElementByPath(wdoor, 'Map Marker'), 'FULL'));
// ak 
// ak 
// ak //					pcell := LinksTo(ElementByName(wdoor,'Cell'));
// ak //					if FixedFormID(pcell) = targetWorld then begin
// ak //						Result := wdoor;
// ak //						Exit;
// ak //					end;
// ak //				end;
// ak //			end;
// ak end;

function findWorldDoor(maxdepth, cell, prevCells, targetWorlds: integer,  IInterface, TStringList, integer) : IInterface;
var 
	cellworld, pcell, wdoor, list, list2, listitem: IInterface;
	skipcell, i,j,k: integer;
	cellworldname: string;
begin
	skipcell := 0;
//	prevCells.Add(IntToStr(FixedFormID(cell)));

	list2 := ChildGroup(cell);
	for k := 0 to ElementCount(list2) -1 do begin
		list := ElementByIndex(ChildGroup(cell), k);
		for i := 0 to  ElementCount(list) - 1 do begin
			listitem := ElementByIndex(list, i);
			if ElementExists(listitem, 'XTEL') then begin
				wdoor := LinksTo(ElementByPath(listitem, 'XTEL\Door'));
				pcell := LinksTo(ElementByName(wdoor,'Cell'));

				cellworld := LinksTo(ElementByName(pcell,'WorldSpace'));
				cellworldname := GetElementEditValues(cellworld, 'FULL');
				if targetWorlds.IndexOf(cellworldname) > -1 then begin
					Result := wdoor;
					Exit;
				end;
 
 				//if FixedFormID(pcell) = targetWorld then begin
 				//	Result := wdoor;
 				//	Exit;
 				//end			
			end;
		end;



		for i := 0 to  ElementCount(list) - 1 do begin
			listitem := ElementByIndex(list, i);
			if ElementExists(listitem, 'XTEL') then begin
				wdoor := LinksTo(ElementByPath(listitem, 'XTEL\Door'));
				pcell := LinksTo(ElementByName(wdoor,'Cell'));

				if maxdepth < 1  then begin
					Continue;
				end;
				
				for j := 0 to prevCells.Count-1 do begin
					if prevCells[j] = IntToStr(FixedFormID(pcell)) then begin
						skipcell := 1;
					end;
				end;
				if skipcell > 0 then begin
//						AddMessage('	skipping ' + IntToStr(FixedFormID(pcell) ));
				end
				else begin
					Result := findWorldDoor(maxdepth-1, pcell, prevCells, targetWorlds);
					Exit;
				end;
			end;
		end;

	end;
	prevCells.Add(IntToStr(FixedFormID(cell)));
end;



// Called before processing
// You can remove it if script doesn't require initialization code
function Initialize: integer;
begin
	AddMessage('{"items":[');
	indexSpc := 0;
  Result := 0;
end;

// called for every record selected in xEdit
function Process(e: IInterface): integer;
	var
		RECORD_FORMID, MODEL_FILENAME, kwda: IInterface;
		sRecordFormID, sModelFilename, cellworldmap, cellworldname: string;
		wdoor, pcell, cellworld, doorcell, doorcellworld: IInterface;
		rec, list, listitem: IInterface;
		line, formid, itemtype, doorcellworldname: string;
		kwIndex, i: integer;
		prevCells, targetWorlds: TStringList;

		
begin
  Result := 0;
  if Signature(e) = 'REFR' then
  begin
	if (Pos('PerkMag', GetElementEditValues(e, 'NAME')) > 0) OR (Pos('BobbleHead_', GetElementEditValues(e, 'NAME')) > 0)  
	OR (Pos('Folon_BOOK_', GetElementEditValues(e, 'NAME')) > 0) OR (Pos('Folon_Misc_VinylRecord_', GetElementEditValues(e, 'NAME')) > 0) then
	begin
		if indexSpc > 0 then begin
			line := ', ';
		end 
		else begin
			line := '';
		end
		indexSpc := indexSpc + 1;
	
		itemtype := '';
		
		//AddMessage('akak');
		//AddMessage(GetElementEditValues(LinksTo(ElementByName(e, 'NAME')), 'EDID'));
		//AddMessage(GetElementEditValues(BaseRecord(e), 'EDID'));
		//AddMessage('akak');
		
		
		
		//kwda := ElementByPath(e, 'KWDA');
		kwda := ElementByPath(BaseRecord(e), 'KWDA');
		for kwIndex := 0 to ElementCount(kwda) - 1 do begin
		
			if GetElementEditValues(LinksTo(ElementByIndex(kwda, kwIndex )), 'EDID') = 'BobbleheadKeyword' then begin
				itemtype := 'bobblehead';
				break;
			end
			else if GetElementEditValues(LinksTo(ElementByIndex(kwda, kwIndex )), 'EDID') = 'PerkMagKeyword' then begin
				itemtype := 'perkmagazine';
			end;
		end;

		if itemtype = '' then begin
			if (Pos('Bobble', GetElementEditValues(e, 'NAME')) > 0) then begin
				itemtype := 'bobblehead';
			end
			else if (Pos('PerkMag', GetElementEditValues(e, 'NAME')) > 0) then begin
				itemtype := 'perkmagazine';
			end
			else if (Pos('Folon_Misc_VinylRecord_', GetElementEditValues(e, 'NAME')) > 0) then begin
				itemtype := 'vinylrecord';
			end;
		end;

		if itemtype = '' then begin
			Exit;
		end;

		line := line + '{"type" :"'+itemtype+'"';
		
		eName := StringReplace(GetElementEditValues(e, 'NAME'), '"', '''',  [rfReplaceAll]);

		line := line + ', "name" :"' + eName  + '"';
		line := line + ', "instanceformid" : "' + IntToHex(FixedFormID(e),8) + '"';
		line := line + ', "description" : ""';

	
		pcell := LinksTo(ElementByName(e,'Cell'));
		cellworld := LinksTo(ElementByName(pcell,'WorldSpace'));
		
		cellworldmap := '';
		cellworldname := '';

		cellworldmap := GetElementEditValues(cellworld, 'ICON');
		cellworldname: = GetElementEditValues(cellworld, 'FULL');
		
		//AddMessage(name +',  cellworldmap:' +cellworldmap +',  cellworldname:' +cellworldname);
		//Exit;
		
		//if cellworldname='London' or cellworldname='Hackney' or cellworldname='Islington' or cellworldname='Camden' or 
		//cellworldname='Westminster' or cellworldname='Bank of England' then begin	
		if (cellworldname <> '') and (cellworldmap <> '') then begin
		//if AnsiCompareText(cellworldname,'') <> 0 and AnsiCompareText(cellworldmap, '') <> 0 then begin
			//worldspace cell in a worldspace with a map
			line := line + ' , "mode" : "1"';
			line := line + ' , "cell" : "' +   GetElementEditValues(pcell, 'EDID')+ '"'; //will need cleanup, maybe blank
			line := line + ' , "world" : "' +   cellworldname + '"'; //should be clean
			//line := line + ' , "map" : "' +   cellworldmap + '"'; //should be clean


			//line := line + ' , "world" : "' +   StringReplace(GetElementEditValues(e, 'CELL'), '"', '''',  [rfReplaceAll]) +'"';
			line := line +  ' , "worldx" : "' + GetElementEditValues(e, 'DATA\Position\X')   +'"';
			line := line +  ' , "worldy" : "' + GetElementEditValues(e, 'DATA\Position\Y')  +'"}';
			AddMessage(line);
		end
		else if cellworldname <> '' then begin
			//worldspace cell in unmapped world
			line := line + ', "mode" : "2"';
			//think this might be them situation as Goodneighbour, Vault81, etc in the base game

			//what to do with these?
			//set world to london and manually set the coords, based on the entrance to the other world? or location of other world?
			//
			//Get cellworld.Parent.PNAM for parent worldspace (only ever london)
			//and cellworld.ONAM for x,y offset (vs parent?) and scale
			line := line + '  , "world" : "' +   cellworldname + '"'; //should be clean
			line := line +  ' , "map" : "unmappedworld"';
			line := line +  ' , "worldx" : "' + GetElementEditValues(e, 'DATA\Position\X')   +'"';
			line := line +  ' , "worldy" : "' + GetElementEditValues(e, 'DATA\Position\Y')  +'"}';
			AddMessage(line);
		end	
		else if cellworldname = '' then begin
			//interior cell
			line := line + ' , "mode" : "3"';
			line := line + ' , "cell" : "' +   GetElementEditValues(pcell, 'FULL')+ '"'; //should be clean
			line := line + ' , "celledid" : "' +   GetElementEditValues(pcell, 'EDID')+ '"'; //should be clean
			line := line + ' , "cellid" : "' +   IntToHex(FixedFormID(pcell),8)+ '"'; //should be clean
			
			
			line := line + ' , "isinterior" : "1"'; 
			//doorwalk to get world and coords
			
			
			prevCells := TStringList.Create;
			targetWorlds := TStringList.Create;
			targetWorlds.Add('London');
			targetWorlds.Add('Islington');
			targetWorlds.Add('Westminster');
			targetWorlds.Add('Hackney');
			targetWorlds.Add('Camden');
			targetWorlds.Add('Bank of England');
			
			wdoor := findWorldDoor(5,  pcell, prevCells, targetWorlds);	//london

			//doorcell := GetElementEditValues(wdoor, 'CELL');
			doorcell := LinksTo(ElementByName(wdoor,'Cell'));
			line := line + ' , "doorcell" : "' +   GetElementEditValues(doorcell, 'FULL')+ '"'; //should be clean
			line := line + ' , "doorcelledid" : "' +   GetElementEditValues(doorcell, 'EDID')+ '"'; //should be clean
			line := line + ' , "doorcellid" : "' +   IntToHex(FixedFormID(doorcell),8)+ '"'; 

			
			doorcellworld := LinksTo(ElementByName(doorcell,'WorldSpace'));
			doorcellworldname := GetElementEditValues(doorcellworld, 'FULL');
			
			line := line + ' , "world" : "' +   doorcellworldname + '"'; //should be clean
			line := line +  ' , "worldx" : "' + GetElementEditValues(wdoor, 'DATA\Position\X')   +'"';
			line := line +  ' , "worldy" : "' + GetElementEditValues(wdoor, 'DATA\Position\Y')  +'"}';			
	
			AddMessage(line);

		end
		else begin
			//shouldn't get here.
			line := line +  ' , "unknownlocation" : "unknownlocation"}';


			AddMessage(line);
		end;

	end;
  end;
end;

// Called after processing
// You can remove it if script doesn't require finalization code
function Finalize: integer;
begin
	AddMessage(']}');
  Result := 0;
end;

end.

