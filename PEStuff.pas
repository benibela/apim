//Not directly part of APIM
//unclear copyright
//headers copied from somewhere??
//functions copyright benito van der zander 2008 ?
unit PEStuff;
{$mode objfpc}{$H+}
interface

uses
  Windows,classes;

const IMAGE_SIZEOF_SHORT_NAME=8;
      IMAGE_NUMBEROF_DIRECTORY_ENTRIES=16;
      IMAGE_DIRECTORY_ENTRY_EXPORT             = 0;
      IMAGE_DIRECTORY_ENTRY_IMPORT             = 1;
type
  (*PImageDosHeader = ^TImageDosHeader;
  _IMAGE_DOS_HEADER = packed record { DOS .EXE header }
    e_magic: Word; { Magic number }
    e_cblp: Word; { Bytes on last page of file }
    e_cp: Word; { Pages in file }
    e_crlc: Word; { Relocations }
    e_cparhdr: Word; { Size of header in paragraphs }
    e_minalloc: Word; { Minimum extra paragraphs needed }
    e_maxalloc: Word; { Maximum extra paragraphs needed }
    e_ss: Word; { Initial (relative) SS value }
    e_sp: Word; { Initial SP value }
    e_csum: Word; { Checksum }
    e_ip: Word; { Initial IP value }
    e_cs: Word; { Initial (relative) CS value }
    e_lfarlc: Word; { File address of relocation table }
    e_ovno: Word; { Overlay number }
    e_res: array[0..3] of Word; { Reserved words }
    e_oemid: Word; { OEM identifier (for e_oeminfo) }
    e_oeminfo: Word; { OEM information; e_oemid specific}
    e_res2: array[0..9] of Word; { Reserved words }
    _lfanew: LongInt; { File address of new exe header }
  end;
  TImageDosHeader = _IMAGE_DOS_HEADER;
    *)
  PIMAGE_FILE_HEADER = ^IMAGE_FILE_HEADER;
  IMAGE_FILE_HEADER = packed record
    Machine: WORD;
    NumberOfSections: WORD;
    TimeDateStamp: DWORD;
    PointerToSymbolTable: DWORD;
    NumberOfSymbols: DWORD;
    SizeOfOptionalHeader: WORD;
    Characteristics: WORD;
  end;

  PIMAGE_DATA_DIRECTORY = ^IMAGE_DATA_DIRECTORY;
  IMAGE_DATA_DIRECTORY = packed record
    VirtualAddress: DWORD;
    Size: DWORD;
  end;

  PIMAGE_SECTION_HEADER = ^IMAGE_SECTION_HEADER;
  IMAGE_SECTION_HEADER = packed record
    Name: packed array[0..IMAGE_SIZEOF_SHORT_NAME - 1] of
    Char;
    VirtualSize: DWORD; // or VirtualSize (union);
    VirtualAddress: DWORD;
    SizeOfRawData: DWORD;
    PointerToRawData: DWORD;
    PointerToRelocations: DWORD;
    PointerToLinenumbers: DWORD;
    NumberOfRelocations: WORD;
    NumberOfLinenumbers: WORD;
    Characteristics: DWORD;
  end;

  PIMAGE_OPTIONAL_HEADER = ^IMAGE_OPTIONAL_HEADER;
  IMAGE_OPTIONAL_HEADER = packed record
   { Standard fields. }
    Magic: WORD;
    MajorLinkerVersion: Byte;
    MinorLinkerVersion: Byte;
    SizeOfCode: DWORD;
    SizeOfInitializedData: DWORD;
    SizeOfUninitializedData: DWORD;
    AddressOfEntryPoint: DWORD;
    BaseOfCode: DWORD;
    BaseOfData: DWORD;
   { NT additional fields. }
    ImageBase: DWORD;
    SectionAlignment: DWORD;
    FileAlignment: DWORD;
    MajorOperatingSystemVersion: WORD;
    MinorOperatingSystemVersion: WORD;
    MajorImageVersion: WORD;
    MinorImageVersion: WORD;
    MajorSubsystemVersion: WORD;
    MinorSubsystemVersion: WORD;
    Reserved1: DWORD;
    SizeOfImage: DWORD;
    SizeOfHeaders: DWORD;
    CheckSum: DWORD;
    Subsystem: WORD;
    DllCharacteristics: WORD;
    SizeOfStackReserve: DWORD;
    SizeOfStackCommit: DWORD;
    SizeOfHeapReserve: DWORD;
    SizeOfHeapCommit: DWORD;
    LoaderFlags: DWORD;
    NumberOfRvaAndSizes: DWORD;
    DataDirectory: packed array
    [0..IMAGE_NUMBEROF_DIRECTORY_ENTRIES - 1] of IMAGE_DATA_DIRECTORY;
    Sections: packed array[0..9999] of IMAGE_SECTION_HEADER;
  end;

  PIMAGE_NT_HEADERS = ^IMAGE_NT_HEADERS;
  IMAGE_NT_HEADERS = packed record
    Signature: DWORD;
    FileHeader: IMAGE_FILE_HEADER;
    OptionalHeader: IMAGE_OPTIONAL_HEADER;
  end;
  PImageNtHeaders = PIMAGE_NT_HEADERS;
  TImageNtHeaders = IMAGE_NT_HEADERS;

  PIMAGE_EXPORT_DIRECTORY = ^IMAGE_EXPORT_DIRECTORY;
  IMAGE_EXPORT_DIRECTORY = packed record
    Characteristics          : DWORD;
    TimeDateStamp            : DWORD;
    MajorVersion             : WORD;
    MinorVersion             : WORD;
    nName                    : DWORD;
    nBase                    : DWORD;
    NumberOfFunctions        : DWORD;//count of all exported functions
    NumberOfNames            : DWORD;//count of named exported functions
    AddressOfFunctions       : DWORD;//rva to all functions
    AddressOfNames           : DWORD;//rva to array of rva of names
    AddressOfNameOrdinals    : DWORD;//rva to 16-bit array of the index of the function in
                                     //AddressOfFunctions
                                     
                                     //AON[1] = Name, AOF[AONO[1]-nBase] = Address of function name
                                     //AON[2] = Name, AOF[AONO[2]-nBase] = Address of function name
                                     //...
  end;
  PImageExportDirectory = PIMAGE_EXPORT_DIRECTORY;
  TImageExportDirectory = IMAGE_EXPORT_DIRECTORY;
//http://win32assembly.online.fr/pe-tut7.html


{ PIMAGE_IMPORT_DESCRIPTOR = ^IMAGE_IMPORT_DESCRIPTOR;
  IMAGE_IMPORT_DESCRIPTOR = packed record
    Characteristics: DWORD; // or original first thunk // 0 for
    terminating null import descriptor // RVA to original unbound IAT
    TimeDateStamp: DWORD; // 0 if not bound,
                          // -1 if bound, and real date\time stamp
                          // in IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT
    (new BIND)            // O.W. date/time stamp of DLL bound to (Old BIND)
    Name: DWORD;
    FirstThunk: DWORD; // PIMAGE_THUNK_DATA // RVA to IAT (if bound this IAT has actual addresses)
    ForwarderChain: DWORD; // -1 if no forwarders
  end;
  TImageImportDescriptor = IMAGE_IMPORT_DESCRIPTOR;
  PImageImportDescriptor = PIMAGE_IMPORT_DESCRIPTOR;}

  PIMAGE_IMPORT_BY_NAME = ^IMAGE_IMPORT_BY_NAME;
  IMAGE_IMPORT_BY_NAME = record
    Hint: Word;
    Name: array[0..0] of Char;
  end;

  PIMAGE_THUNK_DATA = ^IMAGE_THUNK_DATA;
  IMAGE_THUNK_DATA = record
    Whatever: DWORD;
  end;

  PImage_Import_Entry = ^Image_Import_Entry;
  Image_Import_Entry = record
    Characteristics: DWORD;
    TimeDateStamp: DWORD;
    MajorVersion: Word;
    MinorVersion: Word;
    Name: DWORD;
    LookupTable: DWORD;
  end;

const
  IMAGE_DOS_SIGNATURE = $5A4D; // MZ
  IMAGE_OS2_SIGNATURE = $454E; // NE
  IMAGE_OS2_SIGNATURE_LE = $454C; // LE
  IMAGE_VXD_SIGNATURE = $454C; // LE
  IMAGE_NT_SIGNATURE = $00004550; // PE00

function getNTHeaders(hModule: thandle): PImageNtHeaders;
procedure listExportNames(dll: string; names: TStrings);
procedure listExportNames(hmodule: THandle; names: TStrings);
implementation

function getNTHeaders(hModule: thandle): PImageNtHeaders;
var dos: PIMAGEDOSHEADER;
begin
  result:=nil;
  dos:=pointer(hModule);
  if IsBadReadPtr(Dos, SizeOf(TImageDosHeader)) then Exit;
  if Dos^.e_magic <> IMAGE_DOS_SIGNATURE then Exit;
  result := Pointer(dword(Dos) + dos^.e_lfanew);
  // if IsBadReadPtr(NT,SizeOf(TImageNtHeaders)) then exit(nil);
end;



procedure listExportNames(dll: string; names: TStrings);
var temp:thandle;
begin
  temp:=LoadLibrary(pchar(dll));
  if temp=0 then exit;
  listExportNames(temp,names);
  FreeLibrary(temp);
end;

procedure listExportNames(hmodule: THandle; names: TStrings);
var dos : PIMAGEDOSHEADER;
    nt: PImageNtHeaders;
    i,rva: dword;
    exportDirectory: PImageExportDirectory;
    nameArray: pdword;
begin
  names.clear;
  if hmodule=0 then exit;
  dos:=pointer(hModule);
  nt:=getNTHeaders(hModule);
  if nt = nil then exit();

  RVA := NT^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress;
  if RVA = 0 then Exit();

  exportDirectory := Pointer(dword(Dos) + RVA);
  if exportDirectory^.AddressOfNames=0 then exit;
  nameArray:=Pointer(dword(Dos) + exportDirectory^.AddressOfNames);
  names.BeginUpdate;
  for i:=0 to exportDirectory^.NumberOfNames-1 do
    names.add(string(Pchar(dword(Dos)+nameArray[i])));
  names.EndUpdate;
end;
end.

