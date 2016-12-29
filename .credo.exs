%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["./"],
        excluded: []
      },
      checks: [
        {Credo.Check.Design.TagTODO},
        {Credo.Check.Design.TagFIXME, false},
      ]
    }
  ]
}
