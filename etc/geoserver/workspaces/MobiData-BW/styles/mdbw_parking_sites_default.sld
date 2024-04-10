<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ogc="http://www.opengis.net/ogc" version="1.1.0" xmlns:se="http://www.opengis.net/se" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:xlink="http://www.w3.org/1999/xlink">
  <NamedLayer>
    <se:Name>parking_site</se:Name>
    <UserStyle>
      <se:Name>parking_site</se:Name>
      <se:FeatureTypeStyle>
        <se:Rule>
          <se:Name>Geschlossen</se:Name>
          <se:Description>
            <se:Title>Geschlossen</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>realtime_opening_status</ogc:PropertyName>
              <ogc:Literal>CLOSED</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PointSymbolizer>
            <se:Graphic>
              <se:Mark>
                <se:WellKnownName>circle</se:WellKnownName>
                <se:Fill>
                  <se:SvgParameter name="fill">#ed0000</se:SvgParameter>
                </se:Fill>
                <se:Stroke/>
              </se:Mark>
              <se:Size>10</se:Size>
            </se:Graphic>
          </se:PointSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>Keine Echtzeitdaten</se:Name>
          <se:Description>
            <se:Title>Keine Echtzeitdaten</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsNull>
              <ogc:PropertyName>realtime_free_capacity</ogc:PropertyName>
            </ogc:PropertyIsNull>
          </ogc:Filter>
          <se:PointSymbolizer>
            <se:Graphic>
              <se:Mark>
                <se:WellKnownName>circle</se:WellKnownName>
                <se:Fill>
                  <se:SvgParameter name="fill">#615fdf</se:SvgParameter>
                </se:Fill>
                <se:Stroke/>
              </se:Mark>
              <se:Size>10</se:Size>
            </se:Graphic>
          </se:PointSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>Parkplätze verfügbar</se:Name>
          <se:Description>
            <se:Title>Parkplätze verfügbar</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:Div>
                  <ogc:Mul>
                    <ogc:PropertyName>realtime_free_capacity</ogc:PropertyName>
                    <ogc:Literal>1</ogc:Literal>
                  </ogc:Mul>
                  <ogc:Function name="if_then_else">
                    <ogc:Function name="isNull">
                      <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                    </ogc:Function>
                    <ogc:PropertyName>capacity</ogc:PropertyName>
                    <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                  </ogc:Function>
                </ogc:Div>
                <ogc:Literal>0.2</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsNotEqualTo>
                <ogc:PropertyName>realtime_opening_status</ogc:PropertyName>
                <ogc:Literal>CLOSED</ogc:Literal>
              </ogc:PropertyIsNotEqualTo>
            </ogc:And>
          </ogc:Filter>
          <se:PointSymbolizer>
            <se:Graphic>
              <se:Mark>
                <se:WellKnownName>circle</se:WellKnownName>
                <se:Fill>
                  <se:SvgParameter name="fill">#059b02</se:SvgParameter>
                </se:Fill>
                <se:Stroke/>
              </se:Mark>
              <se:Size>10</se:Size>
            </se:Graphic>
          </se:PointSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>Wenige Parkplätze verfügbar</se:Name>
          <se:Description>
            <se:Title>Wenige Parkplätze verfügbar</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:And>
              <ogc:PropertyIsBetween>
                <ogc:Div>
                  <ogc:Mul>
                    <ogc:PropertyName>realtime_free_capacity</ogc:PropertyName>
                    <ogc:Literal>1</ogc:Literal>
                  </ogc:Mul>
                  <ogc:Function name="if_then_else">
                    <ogc:Function name="isNull">
                      <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                    </ogc:Function>
                    <ogc:PropertyName>capacity</ogc:PropertyName>
                    <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                  </ogc:Function>
                </ogc:Div>
                <ogc:LowerBoundary>
                  <ogc:Literal>0.02</ogc:Literal>
                </ogc:LowerBoundary>
                <ogc:UpperBoundary>
                  <ogc:Literal>0.2</ogc:Literal>
                </ogc:UpperBoundary>        
              </ogc:PropertyIsBetween>
              <ogc:PropertyIsNotEqualTo>
                <ogc:PropertyName>realtime_opening_status</ogc:PropertyName>
                <ogc:Literal>CLOSED</ogc:Literal>
              </ogc:PropertyIsNotEqualTo>
            </ogc:And>
          </ogc:Filter>
          <se:PointSymbolizer>
            <se:Graphic>
              <se:Mark>
                <se:WellKnownName>circle</se:WellKnownName>
                <se:Fill>
                  <se:SvgParameter name="fill">#dfab27</se:SvgParameter>
                </se:Fill>
                <se:Stroke/>
              </se:Mark>
              <se:Size>10</se:Size>
            </se:Graphic>
          </se:PointSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>Keine oder sehr wenige Parkplätze verfügbar</se:Name>
          <se:Description>
            <se:Title>Keine oder sehr wenige Parkplätze verfügbar</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>realtime_free_capacity</ogc:PropertyName>
                <ogc:Literal>0</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsLessThanOrEqualTo>
                <ogc:Div>
                  <ogc:Mul>
                    <ogc:PropertyName>realtime_free_capacity</ogc:PropertyName>
                    <ogc:Literal>1</ogc:Literal>
                  </ogc:Mul>
                  <ogc:Function name="if_then_else">
                    <ogc:Function name="isNull">
                      <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                    </ogc:Function>
                    <ogc:PropertyName>capacity</ogc:PropertyName>
                    <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                  </ogc:Function>
                </ogc:Div>
                <ogc:Literal>0.02</ogc:Literal>
              </ogc:PropertyIsLessThanOrEqualTo>
              <ogc:PropertyIsNotEqualTo>
                <ogc:PropertyName>realtime_opening_status</ogc:PropertyName>
                <ogc:Literal>CLOSED</ogc:Literal>
              </ogc:PropertyIsNotEqualTo>
            </ogc:And>
          </ogc:Filter>
          <se:PointSymbolizer>
            <se:Graphic>
              <se:Mark>
                <se:WellKnownName>circle</se:WellKnownName>
                <se:Fill>
                  <se:SvgParameter name="fill">#ed0000</se:SvgParameter>
                </se:Fill>
                <se:Stroke/>
              </se:Mark>
              <se:Size>10</se:Size>
            </se:Graphic>
          </se:PointSymbolizer>
        </se:Rule>
      </se:FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>